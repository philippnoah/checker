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
    
    @IBOutlet var settingsTableView: UITableView!
    
    var taskArray = ["Sync with iCloud", "Chat", "Random Setting"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}