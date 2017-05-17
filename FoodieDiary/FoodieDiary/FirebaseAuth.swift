//
//  FirebaseAuth.swift
//  FoodieDiary
//
//  Created by Aniket Ghode on 5/17/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import Foundation
import FirebaseAuth

extension FirebaseHelper {
    
    func loginUser(_ email: String, _ password: String, completionHandler: @escaping (_ error: Error?) -> Void) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                self.getCurrentUserInfo(user!)
                completionHandler(nil)
            } else {
                completionHandler(error!)
            }
        })
    }
    
    private func getCurrentUserInfo(_ activeUser: FIRUser) {
       if user != activeUser {
            user = activeUser
            let name = user!.email!.components(separatedBy: "@")[0]
            self.displayName = name
        }
    }
    
    func getCurrentUser() -> Bool {
        if let activeUser = FIRAuth.auth()?.currentUser {
            getCurrentUserInfo(activeUser)
            print(activeUser.email!)
            return true
        }
        else {
            return false
        }
    }
    
    func createAccount(_ email: String, _ password: String, completionHandler: @escaping (_ error: Error?) -> Void) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                self.getCurrentUserInfo(user!)
                completionHandler(nil)
            } else {
                completionHandler(error!)
            }
        })
    }
    
    func signOutUser(_ completionHandler: @escaping (_ error: NSError?) -> Void) {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                print("You have successfully signed out!")
                completionHandler(nil)
            } catch let error as NSError {
                completionHandler(error)
            }
        }
    }
    
    func resetPassword(_ email: String, completionHandler: @escaping (_ error: Error?) -> Void) {
        FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
            if error == nil {
                //Print into the console if successfully logged in
                print("Password reset email sent.")
                completionHandler(nil)
            } else {
                completionHandler(error!)
            }
        })
    }
}
