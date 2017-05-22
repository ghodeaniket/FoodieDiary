//
//  PostsTableViewController.swift
//  FoodieDiary
//
//  Created by Aniket Ghode on 5/16/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import UIKit
import FirebaseStorageUI

class PostsTableViewController: UITableViewController, PostsDataSource {
    
    // MARK: - Properties
    
    var posts = [Post]()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Foodie Diary"
        FirebaseHelper.sharedInstance().delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        posts.removeAll()
        
        tableView.reloadData()
        FirebaseHelper.sharedInstance().addObserverForNewPosts()
        ActivityIndicator.sharedInstance().startActivityIndicator(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FirebaseHelper.sharedInstance().removeObserverForNewPosts()
    }
    
    // MARK: - Actions
    
    @IBAction func addNewPost(_ sender: Any) {
        performSegue(withIdentifier: "PostDetails", sender: self)
    }
    
    @IBAction func logoutUser(_ sender: Any) {
        ActivityIndicator.sharedInstance().startActivityIndicator(self)
        FirebaseHelper.sharedInstance().signOutUser { (error) in
            performUIUpdatesOnMain {
                ActivityIndicator.sharedInstance().stopActivityIndicator(self)
                if error == nil {
                    self.dismiss(animated: true, completion: nil)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginSignupVC")
                    self.present(vc!, animated: true, completion: nil)
                } else {
                    self.showAlert("Error", error!.localizedDescription)
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        
        let currentPost = posts[indexPath.row]
        
        if let imageUrl = currentPost.imageUrl {
            let imageRef = FirebaseHelper.sharedInstance().getImage(forImageUrl: imageUrl)
            
            // Cache images with FirebaseUI SDWebImage extension
            
            cell.postImageView.sd_setImage(with: imageRef, placeholderImage: #imageLiteral(resourceName: "placeholder_rev"))
        } else {
            cell.postImageView.image = #imageLiteral(resourceName: "placeholder_rev")
        }
        cell.postContent.text = currentPost.text
        cell.postAuthorLabel.text = "Added By \(currentPost.userName)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let cell = tableView.cellForRow(at: indexPath){
            let currentPost = posts[indexPath.row]
            if currentPost.userName == FirebaseHelper.sharedInstance().displayName {
                
                // TODO: Remove the post from Firebase
                return true
            }
        }
        return false
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Delete")
        }
    }
    
    // MARK: - Post Data Source
    
    func newPostAdded(newPost: Post) {
        ActivityIndicator.sharedInstance().stopActivityIndicator(self)
        posts.append(newPost)
        tableView.reloadData()
    }
}
