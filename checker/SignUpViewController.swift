//
//  LoginViewController.swift
//  checker
//
//  Created by Philipp Eibl on 7/15/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBAction func unwindToLoginViewController(segue: UIStoryboardSegue) { }

    var currentUser: User!
    var listOfUsers: [User] = []
    var ref = FIRDatabaseReference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "signUp" && validation() {
            
            currentUser.username = usernameTextField.text!
            currentUser.password = passwordTextField.text!
            RealmHelper.logout()
            RealmHelper.login(currentUser)
            return true
            
        } else if identifier == "goToLogin" {
            self.dismissViewControllerAnimated(true, completion: nil)
            return true
        }
        return false
    }
    
    func validation() -> Bool {
        if usernameTextField.text != "" && passwordTextField.text != "" {
            if compareWithDataBase() {
                return true
            }
        }
        return false
    }
    
    func compareWithDataBase() -> Bool {
        for user in listOfUsers {
            if usernameTextField.text! == user.username && passwordTextField.text! == user.password {
                return true
            }
        }
        return false
    }
}