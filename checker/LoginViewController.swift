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
    @IBOutlet var loginButton: UIButton!
    
    var currentUser: User?
    var listOfUsers: [User] = []
    var ref = FIRDatabaseReference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        self.getUsers()
        if RealmHelper.checkForUser() != 0 { RealmHelper.logout() }

        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        let usernamePaddingView: UIView = UIView(frame: CGRectMake(0, 0, 10, 0))
        usernameTextField.leftView = usernamePaddingView
        usernameTextField.leftViewMode = .Always
        
        let passwordPaddingView: UIView = UIView(frame: CGRectMake(0, 0, 10, 0))
        passwordTextField.leftView = passwordPaddingView
        passwordTextField.leftViewMode = .Always
        
        usernameTextField.layer.borderWidth = 1
        usernameTextField.layer.borderColor = UIColor.init(red:0.75, green:0.75, blue:0.75, alpha:1.0).CGColor
        
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.init(red:0.75, green:0.75, blue:0.75, alpha:1.0).CGColor

        let highlightedImage: UIImage = UIImage(named: "loginButton.png")!
        let highlightedImageInsets: UIEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        let stretchableHighlightedImage: UIImage = highlightedImage.resizableImageWithCapInsets(highlightedImageInsets)
        loginButton.setBackgroundImage(stretchableHighlightedImage, forState: .Normal)
        loginButton.setTitleColor(.darkGrayColor(), forState: .Selected)
        loginButton.setTitleColor(.darkGrayColor(), forState: .Focused)
        loginButton.setTitleColor(.darkGrayColor(), forState: .Highlighted)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "login" && validation() {
            currentUser?.username = usernameTextField.text!
            currentUser?.password = passwordTextField.text!
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
                    self.currentUser = nil
                    self.currentUser = User()
                    self.currentUser?.buddy = user.buddy
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