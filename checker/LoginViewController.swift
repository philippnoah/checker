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
    
    var currentUser: User? = User()
    var listOfUsers: [User] = []
    var ref = FIRDatabaseReference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        self.getUsers()
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "login" && validation() {
            RealmHelper.logout()
            currentUser!.username = usernameTextField.text!
            currentUser!.password = passwordTextField.text!
            RealmHelper.login(currentUser!)
            return true
            
        } else if identifier == "goToSignUp" {
            return true
        }
        return false
    }
    
    func validation() -> Bool {
        if usernameTextField.text != "" && passwordTextField.text != "" {
            for user in listOfUsers {
                if user.username == self.usernameTextField.text && user.password == self.passwordTextField.text {
                    self.currentUser!.buddy = user.buddy
                    return true
                }
            }
        }
        return false
    }
}

extension LoginViewController {
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