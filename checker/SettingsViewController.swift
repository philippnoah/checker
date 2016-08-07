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
    
    var taskArray = ["Contact", "Block current buddy", "Logout"]
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
        cell.textLabel!.text = self.taskArray[indexPath.row]
        
        switch indexPath.row {
        case 0:
            cell.detailTextLabel?.text = "philippnoah.dev@gmail.com"
            cell.selectionStyle = .None
        case 2:
            cell.textLabel!.textColor = UIColor.redColor()
            cell.detailTextLabel?.text = ""
            //cell.detailTextLabel?.textAlignment = .Center
        default:
            cell.detailTextLabel?.text = ""
        }
        
        let emptyBackgroundCellView = UIView()
        emptyBackgroundCellView.backgroundColor = UIColor(red:0.47, green:0.75, blue:0.22, alpha:0.5)
        cell.selectedBackgroundView = emptyBackgroundCellView
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row {
        case 0:
            self.settingsTableView.cellForRowAtIndexPath(indexPath)?.selectionStyle = .None
        case 2:
            logoutRUSure()
        case 1:
            //flag and remove buddy
            if RealmHelper.getUser()?.buddy == nil { return }
            rUSureRemoveBuddy()
            //if user has already been reported, delete from flaggedUsers and block access (still need to be added)
        default:
            print("default")
        }
        
        self.settingsTableView.deselectRowAtIndexPath(indexPath, animated: true)
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
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func flaggedAndRemovedBuddy() {
        let alert = UIAlertController(title: "Removed buddy", message: "Your buddy has successfully been removed.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func rUSureRemoveBuddy() {
        let alert = UIAlertController(title: "Remove buddy", message: "Are you sure? This action cannot be revoked.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler:  {
            (alert: UIAlertAction!) in
            self.ref.child("flaggedUsers").childByAutoId().setValue(RealmHelper.getUser()?.buddy)
            self.getCurrentUserIdAndDeleteBuddyOnFirebase()
            RealmHelper.setBuddy(RealmHelper.getUser()!, setBuddy: nil)
            LocalDataHelper.buddyTaskArray = []
            self.flaggedAndRemovedBuddy()
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func logoutRUSure() {
        let alert = UIAlertController(title: "Remove buddy", message: "Are you sure? This action cannot be revoked.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler:  {
        (alert: UIAlertAction!) in
            self.tabBarController?.dismissViewControllerAnimated(true, completion: nil)
            self.dismissViewControllerAnimated(true, completion: nil)
            RealmHelper.logout()
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}