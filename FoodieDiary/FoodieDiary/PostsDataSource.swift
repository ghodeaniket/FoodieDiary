//
//  PostsDataSource.swift
//  FoodieDiary
//
//  Created by Aniket Ghode on 5/16/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import Foundation


public protocol PostsDataSource : NSObjectProtocol {
    func newPostAdded(newPost: Post) -> Void
    func removePost(forKey key: String) -> Void
}
