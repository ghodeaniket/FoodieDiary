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
    var displayName = "Anonymous"
    var ref: FIRDatabaseReference!
    fileprivate var _refHandle: FIRDatabaseHandle!
    
    func configureDatabase() {
        print("Configure Database!")
        ref = FIRDatabase.database().reference()
    }
    
    func addPost(post: String) {
        
        let data = [PostFields.text: post, PostFields.name: displayName]
        
        // like specifying "posts/[some auto id]"
        ref.child("posts").childByAutoId().setValue(data)
    }
    
    func addObserverForNewPosts(){
        
        _refHandle = ref.child("posts").observe(.childAdded, with: { (postSnapShot) in
            // Parse Snapshot and create Post object
            let post = postSnapShot.value as! [String: String]
            let name = post[PostFields.name] ?? "[Username]"
            let postText = post[PostFields.text]
            let imageUrl = post[PostFields.imageUrl] ?? ""
            let newPost = Post(userName: name, text: postText!, imageUrl: imageUrl)
            
            self.delegate?.newPostAdded(newPost: newPost)
        })
    }
    
    func removeObserverForNewPosts() {
        ref.removeObserver(withHandle: _refHandle)
    }
    
    // Private constructor
    private override init() {
        super.init()
        configureDatabase()
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> FirebaseHelper {
        struct Singleton {
            static var sharedInstance = FirebaseHelper()
        }
        return Singleton.sharedInstance
    }
}
