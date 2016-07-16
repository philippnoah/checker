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
    @IBAction func createAccountButtonPressed(sender: UIButton) {
    }
    
    var ref = FIRDatabaseReference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        FirebaseHelper.createAccount(usernameTextField.text!, password: passwordTextField.text!)
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //let toDoListViewController = segue.destinationViewController as! ToDoListViewController
        FirebaseHelper.validation(usernameTextField.text!, password: passwordTextField.text!)
    }
    
}