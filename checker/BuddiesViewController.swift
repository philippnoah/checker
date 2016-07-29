//
//  BuddiesViewController.swift
//  checker
//
//  Created by Philipp Eibl on 7/12/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import UIKit
import Firebase

class BuddiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var buddiesTitelLabel: UILabel!
    @IBOutlet var buddyTasksListTableView: UITableView!
    
    var ref = FIRDatabaseReference()
    var currentUser = User()
    var currentBuddy = User()
    var listOfOtherUsersWithoutBuddy: [User] = []
    var buddyTaskArray: [Task] = [] {
        didSet {
            self.buddyTasksListTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        self.currentUser = RealmHelper.getUser()
        self.getUsersWithoutBuddyAndAssignBuddiesIfNecessary()
}
}

extension BuddiesViewController {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buddyTaskArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("buddyCell", forIndexPath: indexPath) as! BuddyTaskCell
        cell.buddyTaskLabel.text = self.buddyTaskArray[indexPath.row].title
        
        return cell
    }
}

extension BuddiesViewController {
    
    func getUsersWithoutBuddyAndAssignBuddiesIfNecessary() {
        
        if self.currentUser.buddy != nil {
            setTasksForBuddyFromFirebase(self.currentUser.buddy!)
            return
        }
        
        ref.child("users").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            //Get users
            guard let tempListOfUsers = snapshot.value! as? [String: AnyObject] else {return}
            
            for tempUser in tempListOfUsers {
                if tempUser.1["buddy"] as? String == nil {
                    let user = User()
                    user.username = tempUser.1["username"] as! String
                    user.password = tempUser.1["password"] as! String
                    user.buddy = tempUser.1["buddy"] as? String
                    if user != self.currentUser {
                        self.listOfOtherUsersWithoutBuddy.append(user)
                    }
                } else {
                    print("no users looking for a buddy. Come back later")
                    return
                }
            }
            
            self.assignBuddies()
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func assignBuddies() {
        //Get random number
        let randomNumber: Int = Int(arc4random_uniform(UInt32(self.listOfOtherUsersWithoutBuddy.count)))
        
        //Set currentUser.buddy
        RealmHelper.setBuddy(self.currentUser, setBuddy: self.listOfOtherUsersWithoutBuddy[randomNumber].username) 
        
        //Assign buddy for currentUser
        assignBuddyForUserOnFirebase(self.currentUser.buddy!, user: self.currentUser)
        
        //Get buddy info and assign currentUser as buddy
        for user in listOfOtherUsersWithoutBuddy {
            if user.username == self.currentUser.buddy {
                self.currentBuddy.username = user.username
                self.currentBuddy.password = user.password
                self.currentBuddy.buddy = currentUser.username
            }
        }
        assignBuddyForUserOnFirebase(self.currentUser.username, user: self.currentBuddy)
    }
    
    func assignBuddyForUserOnFirebase(buddy: String, user: User) {
        
        let key = ref.child("users").childByAutoId().key
        let post = ["username": user.username,
                    "password": user.password,
                    "buddy": buddy]
        
        let childUpdates = ["/users/\(key)": post]
        ref.updateChildValues(childUpdates)
        setTasksForBuddyFromFirebase(self.currentUser.buddy!)
    }
    
    func setTasksForBuddyFromFirebase(buddy: String) {
        
        ref.child("completedTasks").child(buddy).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            // Get user value
            guard let tempListOfTasks = snapshot.value! as? [String: AnyObject] else {print("nope");return}
            
            self.buddyTaskArray = []
            for tempTask in tempListOfTasks {
                
                let title = tempTask.1["title"] as! String
                let descriptionText = tempTask.1["description"] as! String
                //let dueDate = tempTask.1["dueDate"] as! String
                let task = Task(title: title, descriptionText: descriptionText, dueDate: NSDate())
                self.buddyTaskArray.append(task)
                
            }
            print(self.buddyTaskArray.count)
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
}
