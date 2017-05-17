//
//  AppDelegate.swift
//  FoodieDiary
//
//  Created by Aniket Ghode on 5/15/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Set the status bar to light color
        UIApplication.shared.statusBarStyle = .lightContent
        
        // Setup connection with the Firebase FoodDiary App 
        FIRApp.configure()
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        var viewControllerIdentifier: String
        if FirebaseHelper.sharedInstance().getCurrentUser() {
            viewControllerIdentifier = "HomeViewController"
        } else {
            viewControllerIdentifier = "LoginSignupVC"
        }
        
        let initialViewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier)

        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        return true
    }

}

