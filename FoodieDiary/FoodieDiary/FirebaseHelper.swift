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
    var displayName = "Anonymous"
    
    var ref: FIRDatabaseReference!
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
    }
    
    func addPost(post: String) {
        
        let data = [PostFields.text: post, PostFields.name: displayName]
        
        // like specifying "posts/[some auto id]"
        ref.child("posts").childByAutoId().setValue(data)
    }
}
