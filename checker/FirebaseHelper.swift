//
//  FirebaseHelper.swift
//  checker
//
//  Created by Philipp Eibl on 7/15/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class FirebaseHelper {
    static let ref = FIRDatabase.database().reference()
    
    static func getUsers() -> [User] {
        var tempListOfUsers = [User]()
        
        _ = ref.child("users").observeEventType(FIRDataEventType.ChildAdded, withBlock: { (snapshot) in
            guard let users = snapshot.value as? [String: AnyObject]
                else {
                    print(snapshot.value)
                    print("users query didnt work")
                    return
            }
            print("i no work")
            for x in users.values {
                tempListOfUsers.append(x as! User)
            }
        })
        return tempListOfUsers
    }
    
    static func createAccount(username: String, password: String) {
        ref.child("users").childByAutoId().setValue(["username": username, "password": password])
    }
    
    static func validation(username: String, password: String) -> Bool {
        let listOfUsers : [User] = FirebaseHelper.getUsers()
        
        for tempUser in listOfUsers {
            if  username == tempUser.username &&  password == tempUser.password {
                return true
            }
        }
        
        return false
    }
}