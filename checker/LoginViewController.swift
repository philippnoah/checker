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
    
    var currentUser: User = User()
    var listOfUsers: [User] = []
    var ref = FIRDatabaseReference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "login" && validation() {
            
            currentUser.username = usernameTextField.text!
            currentUser.password = passwordTextField.text!
            RealmHelper.logout()
            RealmHelper.login(currentUser)
            return true
            
        } else if identifier == "goToSignUp" {
            return true
        }
        return false
    }
    
    func validation() -> Bool {
        if usernameTextField.text != "" && passwordTextField.text != "" {
            return true
        }
        return false
    }
}