//
//  Post.swift
//  FoodieDiary
//
//  Created by Aniket Ghode on 5/16/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import Foundation
import Firebase

public struct Post {

    var key: String
    var userName: String
    var text: String
    var imageUrl: String?
    
    init(_ snapShot: FIRDataSnapshot) {        
        let post = snapShot.value as! [String: String]
        key = snapShot.key
        userName = post["name"] ?? "[Username]"
        text = post["text"] ?? "Empty Post"
        imageUrl = post["photoUrl"]
    }
}
