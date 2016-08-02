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
        self.getUsers()
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
            if compareWithFirebaseData() {
                return true
            }
        }
        return false
    }
    
    func compareWithFirebaseData() -> Bool {
        for user in listOfUsers {
            if usernameTextField.text! == user.username && passwordTextField.text! == user.password {
                return true
            }
        }
        return false
    }
}

extension SignUpViewController {
    func getUsers() {
        
        ref.child("users").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            //Get users
            guard let tempListOfUsers = snapshot.value! as? [String: AnyObject] else {return}
            
            for tempUser in tempListOfUsers {
                let user = User()
                user.username = tempUser.1["username"] as! String
                user.password = tempUser.1["password"] as! String
                user.buddy = tempUser.1["buddy"] as? String
                self.listOfUsers.append(user)
                
            }
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
}