//
//  SettingsViewController.swift
//  checker
//
//  Created by Philipp Eibl on 7/12/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var settingsTitleLabel: UILabel!
    @IBOutlet var settingsTableView: UITableView!
    
    var taskArray = ["Block current buddy", "Logout"]
    var ref = FIRDatabaseReference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        self.settingsTableView.tableFooterView = UIView(frame: CGRectZero)
        self.settingsTableView.contentInset = UIEdgeInsetsMake(1, 0, 0, 0)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("settingCell", forIndexPath: indexPath) as! SettingCell
        cell.settingTitleLabel.text = self.taskArray[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row {
        case 1:
            navigationController?.dismissViewControllerAnimated(true, completion: nil)
            tabBarController?.dismissViewControllerAnimated(true, completion: nil)
            self.dismissViewControllerAnimated(true, completion: nil)
            RealmHelper.logout()
        case 0:
            //flag and remove buddy
            if RealmHelper.getUser()?.buddy == nil { return }
            //rUSure()
            //if user has already been reported, delete from flaggedUsers and block access (still need to be added)
            self.ref.child("flaggedUsers").childByAutoId().setValue(RealmHelper.getUser()?.buddy)
            getCurrentUserIdAndDeleteBuddyOnFirebase()
            RealmHelper.setBuddy(RealmHelper.getUser()!, setBuddy: nil)
            LocalDataHelper.buddyTaskArray = []
            flaggedAndRemovedBuddy()
            //display alert(1: r u sure?, 2: deleted)
        default:
            print("default")
        }
    }
    
    func getCurrentUserIdAndDeleteBuddyOnFirebase() {
        
        ref.child("users").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            //Get users
            guard let tempListOfUsers = snapshot.value! as? [String: AnyObject] else {return}
            
            for tempUser in tempListOfUsers {
                
                if tempUser.1["username"] as? String == RealmHelper.getUser()?.username {
                    self.ref.child("users").child(tempUser.0).child("buddy").setValue(nil)
                }
        
            }
             
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func flaggedAndRemovedBuddy() {
        let alert = UIAlertController(title: "Removed buddy", message: "Your buddy has successfully been removed.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func rUSure() {
        let alert = UIAlertController(title: "Remove buddy", message: "Are you sure? This action cannot be revoked.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}