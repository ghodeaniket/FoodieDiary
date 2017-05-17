//
//  PostsTableViewController.swift
//  FoodieDiary
//
//  Created by Aniket Ghode on 5/16/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import UIKit

class PostsTableViewController: UITableViewController, PostsDataSource {
    
    // MARK: - Properties
    
    var posts = [Post]()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Foodie Diary"
        FirebaseHelper.sharedInstance().delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        posts.removeAll()
        
        tableView.reloadData()
        FirebaseHelper.sharedInstance().addObserverForNewPosts()
    }
    deinit {
        FirebaseHelper.sharedInstance().removeObserverForNewPosts()
    }
    
    // MARK: - Actions
    
    @IBAction func addNewPost(_ sender: Any) {
        performSegue(withIdentifier: "PostDetails", sender: self)
    }
    
    @IBAction func logoutUser(_ sender: Any) {
        FirebaseHelper.sharedInstance().signOutUser { (error) in
            if error == nil {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginSignupVC")
                self.present(vc!, animated: true, completion: nil)
            } else {
                self.showAlert("Error", error!.localizedDescription)
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
        cell.postImageView.image = #imageLiteral(resourceName: "placeholder_rev")
        cell.imageActivityIndicator.isHidden = true
        if let imageUrl = currentPost.imageUrl {
            cell.imageActivityIndicator.isHidden = false
            cell.imageActivityIndicator.startAnimating()
            FirebaseHelper.sharedInstance().getImage(forImageUrl: imageUrl, completionHandler: { (data, error) in
                // display image
                let postImage = UIImage.init(data: data!, scale: 50)
                // check if the cell is still on the screen, if so, update cell image
                if cell == tableView.cellForRow(at: indexPath) {
                    DispatchQueue.main.async {
                        cell.postImageView?.image = postImage
                        cell.setNeedsLayout()
                    }
                }
                cell.imageActivityIndicator.isHidden = true
                cell.imageActivityIndicator.stopAnimating()
            })
        }
        
        // Configure the cell...
        cell.postContent.text = currentPost.text
        
        return cell
    }
    
    // MARK: - Post Data Source
    
    func newPostAdded(newPost: Post) {
        posts.append(newPost)
        tableView.reloadData()
    }
}
