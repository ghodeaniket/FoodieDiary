//
//  AuthenticationViewController.swift
//  FoodieDiary
//
//  Created by Aniket Ghode on 5/17/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {

    // MARK: - Properties
    
    var keyboardOnScreen = false
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var dismissKeyboardRecognizer: UITapGestureRecognizer!
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    // MARK: - Actions
    
    @IBAction func createAccount(_ sender: Any) {
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            showAlert("Error", "Email or Password Empty.")
        } else {
            ActivityIndicator.sharedInstance().startActivityIndicator(self)
            FirebaseHelper.sharedInstance().createAccount(emailTextField.text!, passwordTextField.text!, completionHandler: { (error) in
                performUIUpdatesOnMain {
                    ActivityIndicator.sharedInstance().stopActivityIndicator(self)
                    if error == nil {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
                        self.present(vc!, animated: true, completion: nil)
                    } else {
                        self.showAlert("Error", error!.localizedDescription)
                    }
                }
            })
        }
    }
    
    @IBAction func loginUser(_ sender: Any) {
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            showAlert("Error", "Email or Password Empty.")
        } else {
            ActivityIndicator.sharedInstance().startActivityIndicator(self)
            FirebaseHelper.sharedInstance().loginUser(emailTextField.text!, passwordTextField.text!, completionHandler: { (error) in
                ActivityIndicator.sharedInstance().stopActivityIndicator(self)
                performUIUpdatesOnMain {
                    if error == nil {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
                        self.present(vc!, animated: true, completion: nil)
                    } else {
                        self.showAlert("Error", error!.localizedDescription)
                    }
                }
            })
        }
    }
    
    @IBAction func resetPassword(_ sender: Any) {
        if let email = emailTextField.text, email.isEmpty {
            showAlert("Error", "Please enter your email")
        } else {
            FirebaseHelper.sharedInstance().resetPassword(emailTextField.text!, completionHandler: { (error) in
                if error == nil {
                    self.showAlert("Success!", "Password reset email sent.")
                    self.emailTextField.text = ""
                } else {
                    self.showAlert("Error", error!.localizedDescription)
                }
            })
        }
    }
    
    @IBAction func tappedView(_ sender: Any) {
        resignTextFields()
    }
}

// MARK: - AuthenticationViewController (Notifications)

extension AuthenticationViewController {
    
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

// MARK: - AuthenticationViewController: UITextFieldDelegate

extension AuthenticationViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignTextFields()
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
    
    func resignTextFields() {
        if emailTextField.isFirstResponder {
            emailTextField.resignFirstResponder()
        }
        if passwordTextField.isFirstResponder {
            passwordTextField.resignFirstResponder()
        }
    }
}


