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
    var storageRef: FIRStorageReference!
    var user: FIRUser?
    var displayName = "Anonymous"
    
    var posts = [Post]()
    
    func configureDatabase() {
        print("Configure Database!")
        ref = FIRDatabase.database().reference()
    }
    
    func configureStorage() {
        storageRef = FIRStorage.storage().reference()
    }
    
    func addPost(post: String, photoData: Data?, completionHandler: @escaping (_ error: Error?) -> Void) {
        var data = [PostFields.text: post, PostFields.name: displayName]
        
        if let photoData = photoData {
            // build the path using user's ID and a timestamp
            let imagePath = "chat_photos/" + FIRAuth.auth()!.currentUser!.uid + "\(Double(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
            
            //set content type to "image\jpeg in firebase storage meta data"
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            // create a child node at imagepath with photoData and metadata
            
            isFirebaseReachable { (status) in
                if status {
                    self.storageRef.child(imagePath).put(photoData, metadata: metadata) { (metadata, error) in
                        if let error = error {
                            print("error uploading: \(error)")
                            completionHandler(error)
                            return
                        }
                        // set imageUrl value for the message
                        data[PostFields.imageUrl] = self.storageRef.child((metadata?.path)!).description
                        self.ref.child("posts").childByAutoId().setValue(data)
                        completionHandler(nil)
                    }
                } else {
                    self.storageRef.child(imagePath).put(photoData, metadata: metadata) { (metadata, error) in
                        if let error = error {
                            print("error uploading: \(error)")
                            completionHandler(error)
                            return
                        }
                        // set imageUrl value for the message
                        data[PostFields.imageUrl] = self.storageRef.child((metadata?.path)!).description
                        self.ref.child("posts").childByAutoId().setValue(data)
                        completionHandler(nil)
                    }
                    completionHandler(nil)
                }
            }          
        } else {
            // like specifying "posts/[some auto id]"
            ref.child("posts").childByAutoId().setValue(data)
            completionHandler(nil)
        }
    }
    
    func removePost(post: Post, completionHandler: @escaping (_ error: Error?) -> Void) {
        isFirebaseReachable { (status) in
            if status {
                self.ref.child("posts").child(post.key).removeValue { (error, snapShotRef) in
                    if (error != nil) {
                        completionHandler(nil)
                    } else {
                        completionHandler(error)
                    }
                }
            } else {
                self.ref.child("posts").child(post.key).removeValue()
                // If offline return immediately since the operation is queued.
                completionHandler(nil)
            }
        }
    }
    
    func addObserverForPosts(){
        
        ref.child("posts").observe(.childAdded, with: { (postSnapShot) in
            // Parse Snapshot and create Post object
            
            let newPost = Post(postSnapShot)
            self.posts.insert(newPost, at: 0)
            self.delegate?.refreshDataSource()
        })
        
        ref.child("posts").observe(.childRemoved, with: { (postSnapShot) in
            if let index = self.posts.index(where: {$0.key == postSnapShot.key}) {
                self.posts.remove(at: index)
                self.delegate?.refreshDataSource()
            }
        })
    }
    
    func getImage(forImageUrl imageUrl: String) -> FIRStorageReference {
        return FIRStorage.storage().reference(forURL: imageUrl)
    }
    
    func removeObserverForNewPosts() {
        ref.removeAllObservers()
    }
    
    func isFirebaseReachable(completionHandler: @escaping (_ status: Bool) -> Void) {
        FIRDatabase.database().reference(withPath: ".info/connected").observe(.value, with: { snapshot in
            if snapshot.value as? Bool ?? false {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        })
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
