//
//  SettingsViewController.swift
//  checker
//
//  Created by Philipp Eibl on 7/12/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var settingsTitleLabel: UILabel!
    @IBAction func unwindToToDoListViewController(segue: UIStoryboardSegue) { }
    @IBOutlet var settingsTableView: UITableView!
    
    var taskArray = ["Logout"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        case 0:
            
            tabBarController!.dismissViewControllerAnimated(true, completion: nil)
            self.dismissViewControllerAnimated(true, completion: nil)
            
        default:
            print("defualt")
        }
    }
}