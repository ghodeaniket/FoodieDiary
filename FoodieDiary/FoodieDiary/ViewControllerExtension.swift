//
//  ViewControllerExtension.swift
//  FoodieDiary
//
//  Created by Aniket Ghode on 5/17/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
