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
    
    var ref = FIRDatabaseReference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        
    }
    
}