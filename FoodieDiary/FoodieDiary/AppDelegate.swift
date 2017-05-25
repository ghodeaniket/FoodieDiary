//
//  AppDelegate.swift
//  FoodieDiary
//
//  Created by Aniket Ghode on 5/15/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Set the status bar to light color
        UIApplication.shared.statusBarStyle = .lightContent
        
        // Setup connection with the Firebase FoodDiary App 
        FIRApp.configure()
        
        // enable disk persistence
        FIRDatabase.database().persistenceEnabled = true

        configureInitialVC()
        
        return true
    }

    private func configureInitialVC() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        var viewControllerIdentifier: String
        
        // Check if user is logged in
        if FirebaseHelper.sharedInstance().getCurrentUser() {
            // if user is logged in then show Home View Controller
            viewControllerIdentifier = "HomeViewController"
        } else {
            viewControllerIdentifier = "LoginSignupVC"
        }
        
        let initialViewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier)
        
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
}

