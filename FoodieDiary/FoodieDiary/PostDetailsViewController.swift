//
//  PostDetailsViewController.swift
//  FoodieDiary
//
//  Created by Aniket Ghode on 5/16/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import UIKit

class PostDetailsViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: Properties
    
    var postLength: NSNumber = 100
    var keyboardOnScreen = false
    var photoData: Data?
    
    // MARK: Outlets
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postDescription: UITextView!
    @IBOutlet var dismissKeyboardRecognizer: UITapGestureRecognizer!
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    // MARK: Actions
    
    @IBAction func savePost(_ sender: Any) {
        if !postDescription.text.isEmpty {
            ActivityIndicator.sharedInstance().startActivityIndicator(self)
            FirebaseHelper.sharedInstance().addPost(post: postDescription.text!, photoData: photoData, completionHandler: { (error) in
                performUIUpdatesOnMain {
                    ActivityIndicator.sharedInstance().stopActivityIndicator(self)
                    if let _ = error {
                        self.showAlert("Error", "Unknown Error while adding post!")
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
    @IBAction func tappedView(_ sender: Any) {
        resignTextView()
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Helper
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            present(picker, animated: true, completion: nil)
        } else {
            showAlert("Warning", "Camera not available!")
        }
    }
    
    private func openGallery() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
}

// MARK: - PostDetailsViewController: UIImagePickerControllerDelegate

extension PostDetailsViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String:Any]) {
        // constant to hold the information about the photo
        if let photo = info[UIImagePickerControllerOriginalImage] as? UIImage, let photoData = UIImageJPEGRepresentation(photo, 0.8) {
            self.photoData = photoData
            self.postImageView.image = UIImage(data: photoData)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - FCViewController (Notifications)

extension PostDetailsViewController {
    
    func subscribeToKeyboardNotifications() {
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
    }
    
    func subscribeToNotification(_ name: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - PostDetailsViewController: UITextViewDelegate

extension PostDetailsViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // set the maximum length for the post
        guard let postText = textView.text else { return true }
        let newLength = postText.utf16.count + text.utf16.count - range.length
        return newLength <= postLength.intValue
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == "Add New Review" {
            textView.text = ""
        }
        return true
    }
    
    // MARK: Show/Hide Keyboard
    
    func keyboardWillShow(_ notification: Notification) {
        if !keyboardOnScreen {
            self.view.frame.origin.y -= self.keyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if keyboardOnScreen {
            self.view.frame.origin.y += self.keyboardHeight(notification)
        }
    }
    
    func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
        dismissKeyboardRecognizer.isEnabled = true
    }
    
    func keyboardDidHide(_ notification: Notification) {
        dismissKeyboardRecognizer.isEnabled = false
        keyboardOnScreen = false
    }
    
    func keyboardHeight(_ notification: Notification) -> CGFloat {
        return ((notification as NSNotification).userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.height
    }
    
    func resignTextView() {
        if postDescription.isFirstResponder {
            postDescription.resignFirstResponder()
        }
    }
}
