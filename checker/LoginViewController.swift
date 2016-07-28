//
//  LoginViewController.swift
//  checker
//
//  Created by Philipp Eibl on 7/15/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "" {}
        return true
    }
    
    func validation() {
        
    }
}