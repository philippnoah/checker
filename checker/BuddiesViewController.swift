//
//  BuddiesViewController.swift
//  checker
//
//  Created by Philipp Eibl on 7/12/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import UIKit
import Firebase
import CCMPopup

class BuddiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var buddiesTitelLabel: UILabel!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var buddyTasksListTableView: UITableView!
    @IBAction func segmentedControlValueChanged(sender: UISegmentedControl) {
        self.buddyTasksListTableView.reloadData()
    }
    
    var ref = FIRDatabaseReference()
    var currentUser = User()
    var currentBuddy = User()
    var listOfOtherUsersWithoutBuddy: [User] = []
    var buddyTaskArray: [Task] = [] {
        didSet {
            self.buddyTasksListTableView.reloadData()
        }
    }
    var complimentsArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        self.currentUser = RealmHelper.getUser()!
        self.buddyTaskArray = LocalDataHelper.buddyTaskArray
        self.getUsersWithoutBuddyAndAssignBuddiesIfNecessary()
        setUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.buddyTasksListTableView.reloadData()
    }
    
    func setUI() {
        self.navigationController?.navigationBar.backgroundColor = UIColor.whiteColor()
        self.segmentedControl.tintColor = UIColor(red:0.47, green:0.75, blue:0.22, alpha:1.0)
        self.buddyTasksListTableView.tableFooterView = UIView(frame: CGRectZero)
    }
}

extension BuddiesViewController {
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRectZero)
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRectZero)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return self.buddyTaskArray.count
        } else {
            return complimentsArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("buddyCell", forIndexPath: indexPath) as! BuddyTaskCell
        
        if segmentedControl.selectedSegmentIndex == 0 {
            cell.textLabel!.text = self.buddyTaskArray[indexPath.row].title
            cell.detailTextLabel?.text = self.currentUser.buddy! + "'s task"
            
            if buddyTaskArray.count == 0 {
                cell.textLabel!.text = "Your buddy has no tasks..."
                cell.backgroundColor = UIColor(white:0.06, alpha:1.0)
            }
            
        } else if segmentedControl.selectedSegmentIndex == 1 {
            cell.textLabel!.text = self.complimentsArray[indexPath.row]
            cell.detailTextLabel?.text = ""
            cell.selectionStyle = .None
            
            if complimentsArray.count == 0 {
                cell.textLabel!.text = "Complete tasks to receive compliments from your buddy."
                cell.backgroundColor = UIColor(white:0.06, alpha:1.0)}
        }
        
        let emptyBackgroundCellView = UIView()
        emptyBackgroundCellView.backgroundColor = UIColor(red:0.47, green:0.75, blue:0.22, alpha:0.5)
        cell.selectedBackgroundView = emptyBackgroundCellView
        
        return cell
    }
}

extension BuddiesViewController {
    
    func getUsersWithoutBuddyAndAssignBuddiesIfNecessary() {
        
        if self.currentUser.buddy != nil {
            setTasksForBuddyFromFirebase(self.currentUser.buddy!)
            setCompliments()
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
    
    func setCompliments() {
        
        ref.child("compliments").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            //Get users
            guard let tempListOfCompliments = snapshot.value! as? [String: AnyObject] else {return}
            
            for tempCompliment in tempListOfCompliments {
                if tempCompliment.1["toUser"] as! String == self.currentUser.username! {
                    self.complimentsArray.append(tempCompliment.1["compliment"] as! String)
                }
            }
            
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
            guard let tempListOfTasks = snapshot.value! as? [String: AnyObject] else {
                print("nope")
                return
            }
            
            LocalDataHelper.buddyTaskArray = []
            for tempTask in tempListOfTasks {
                
                let title = tempTask.1["title"] as! String
                let descriptionText = tempTask.1["description"] as! String
    
                let task = Task(title: title, descriptionText: descriptionText, dueDate: NSDate())
                LocalDataHelper.buddyTaskArray.append(task)
                
            }
            self.buddyTaskArray = LocalDataHelper.buddyTaskArray
            self.buddyTasksListTableView.reloadData()
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

extension BuddiesViewController {
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if segmentedControl.selectedSegmentIndex == 0 {
            return true
        } else {
            return false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue is CCMPopupSegue) {
            let popupSegue: CCMPopupSegue = (segue as! CCMPopupSegue)
            popupSegue.destinationBounds = CGRectMake(0, 0, 300, 300)
            popupSegue.backgroundViewColor = UIColor.blackColor()
            popupSegue.backgroundViewAlpha = 0.3
            popupSegue.backgroundBlurRadius = 15
            popupSegue.dismissableByTouchingBackground = true
            let complimentViewController = segue.destinationViewController as! ComplimentViewController
            complimentViewController.buddiesViewController = self
        }
    }
    
}