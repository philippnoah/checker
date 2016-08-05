//
//  LoginViewController.swift
//  checker
//
//  Created by Philipp Eibl on 7/15/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import UIKit
import Firebase
import CCMPopup

class SignUpViewController: UIViewController {
    
    @IBOutlet var termsButton: UIButton!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBAction func unwindToLoginViewController(segue: UIStoryboardSegue) { }
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var createAccountButton: UIButton!
    @IBAction func goToLogin(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    var currentUser: User!
    var listOfUsers: [User] = []
    var ref = FIRDatabaseReference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        self.getUsers()
        if RealmHelper.checkForUser() != 0 { RealmHelper.logout() }

        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        
        let usernamePaddingView: UIView = UIView(frame: CGRectMake(0, 0, 10, 0))
        usernameTextField.leftView = usernamePaddingView
        usernameTextField.leftViewMode = .Always
        
        let passwordPaddingView: UIView = UIView(frame: CGRectMake(0, 0, 10, 0))
        passwordTextField.leftView = passwordPaddingView
        passwordTextField.leftViewMode = .Always
        
        let confirmPasswordPaddingView: UIView = UIView(frame: CGRectMake(0, 0, 10 ,0))
        confirmPasswordTextField.leftView = confirmPasswordPaddingView
        confirmPasswordTextField.leftViewMode = .Always
        
        usernameTextField.layer.borderWidth = 1
        usernameTextField.layer.borderColor = UIColor.init(red:0.75, green:0.75, blue:0.75, alpha:1.0).CGColor
        
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.init(red:0.75, green:0.75, blue:0.75, alpha:1.0).CGColor
        
        confirmPasswordTextField.layer.borderWidth = 1
        confirmPasswordTextField.layer.borderColor = UIColor.init(red:0.75, green:0.75, blue:0.75, alpha:1.0).CGColor
        
        let highlightedImage: UIImage = UIImage(named: "loginButton.png")!
        let highlightedImageInsets: UIEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        let stretchableHighlightedImage: UIImage = highlightedImage.resizableImageWithCapInsets(highlightedImageInsets)
        createAccountButton.setBackgroundImage(stretchableHighlightedImage, forState: .Normal)
        createAccountButton.setTitleColor(.darkGrayColor(), forState: .Selected)
        createAccountButton.setTitleColor(.darkGrayColor(), forState: .Focused)
        createAccountButton.setTitleColor(.darkGrayColor(), forState: .Highlighted)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
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
        } else if identifier == "showTerms" {
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue is CCMPopupSegue) {
            let popupSegue: CCMPopupSegue = (segue as! CCMPopupSegue)
            popupSegue.destinationBounds = CGRectMake(0, 0, 350, 500)
            popupSegue.backgroundViewColor = UIColor.blackColor()
            popupSegue.backgroundViewAlpha = 0.3
            popupSegue.backgroundBlurRadius = 15
            popupSegue.dismissableByTouchingBackground = true

        }
    }
}