//
//  FirebaseHelper.swift
//  FoodieDiary
//
//  Created by Aniket Ghode on 5/16/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import UIKit
import Firebase

class FirebaseHelper: NSObject {
    
    // MARK: Properties
    var delegate: PostsDataSource?
    var ref: FIRDatabaseReference!
    fileprivate var _refHandle: FIRDatabaseHandle!
    var storageRef: FIRStorageReference!
    var user: FIRUser?
    var displayName = "Anonymous"
    
    func configureDatabase() {
        print("Configure Database!")
        ref = FIRDatabase.database().reference()
    }
    
    func configureStorage() {
        storageRef = FIRStorage.storage().reference()
    }
    
    
    
    
    func addPost(post: String, photoData: Data?) {
        var data = [PostFields.text: post, PostFields.name: displayName]
        
        if let photoData = photoData {
            // build the path using user's ID and a timestamp
            let imagePath = "chat_photos/" + FIRAuth.auth()!.currentUser!.uid + "\(Double(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
            
            //set content type to "image\jpeg in firebase storage meta data"
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            // create a child node at imagepath with photoData and metadata
            storageRef.child(imagePath).put(photoData, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("error uploading: \(error)")
                    return
                }
                // set imageUrl value for the message
                data[PostFields.imageUrl] = self.storageRef.child((metadata?.path)!).description
                self.ref.child("posts").childByAutoId().setValue(data)
            }
        } else {
            // like specifying "posts/[some auto id]"
            ref.child("posts").childByAutoId().setValue(data)
        }
        
        
    }
    
    func addObserverForNewPosts(){
        
        _refHandle = ref.child("posts").observe(.childAdded, with: { (postSnapShot) in
            // Parse Snapshot and create Post object
            let post = postSnapShot.value as! [String: String]
            let name = post[PostFields.name] ?? "[Username]"
            let postText = post[PostFields.text] ?? "Empty Post"
            let imageUrl = post[PostFields.imageUrl]
            let newPost = Post(userName: name, text: postText, imageUrl: imageUrl)
            
            self.delegate?.newPostAdded(newPost: newPost)
        })
    }
    
    func getImage(forImageUrl imageUrl: String, completionHandler: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        FIRStorage.storage().reference(forURL: imageUrl).data(withMaxSize: INT64_MAX, completion: { (data, error) in
            guard error == nil else {
                print("error downloading: \(error)")
                return
            }            
            completionHandler(data, error)
        })

    }
    
    func removeObserverForNewPosts() {
        ref.removeObserver(withHandle: _refHandle)
    }
    
    // Private constructor
    private override init() {
        super.init()
        configureDatabase()
        configureStorage()
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> FirebaseHelper {
        struct Singleton {
            static var sharedInstance = FirebaseHelper()
        }
        return Singleton.sharedInstance
    }
}
