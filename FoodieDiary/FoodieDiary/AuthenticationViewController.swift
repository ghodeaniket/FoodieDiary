//
//  AuthenticationViewController.swift
//  FoodieDiary
//
//  Created by Aniket Ghode on 5/17/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    
    @IBAction func createAccount(_ sender: Any) {
        if let email = emailTextField.text, email.isEmpty {
            showAlert("Error", "Please enter your email and password")
        } else {
            FirebaseHelper.sharedInstance().createAccount(emailTextField.text!, passwordTextField.text!, completionHandler: { (error) in
                if error == nil {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
                    self.present(vc!, animated: true, completion: nil)
                } else {
                    self.showAlert("Error", error!.localizedDescription)
                }
            })
        }
    }
    
    @IBAction func loginUser(_ sender: Any) {
        if let email = emailTextField.text, email.isEmpty {
            showAlert("Error", "Please enter your email and password")
        } else {
            FirebaseHelper.sharedInstance().loginUser(emailTextField.text!, passwordTextField.text!, completionHandler: { (error) in
                if error == nil {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
                    self.present(vc!, animated: true, completion: nil)
                } else {
                    self.showAlert("Error", error!.localizedDescription)
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
}
