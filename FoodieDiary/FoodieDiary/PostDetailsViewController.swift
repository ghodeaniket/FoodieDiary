//
//  PostDetailsViewController.swift
//  FoodieDiary
//
//  Created by Aniket Ghode on 5/16/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import UIKit

class PostDetailsViewController: UIViewController {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postDescription: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func savePost(_ sender: Any) {
        if !postDescription.text.isEmpty {
            FirebaseHelper.sharedInstance().addPost(post: postDescription.text!)
        }
    }
}
