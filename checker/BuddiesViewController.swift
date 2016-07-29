//
//  BuddiesViewController.swift
//  checker
//
//  Created by Philipp Eibl on 7/12/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import UIKit

class BuddiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var buddiesTitelLabel: UILabel!
    
    @IBOutlet var buddyTasksListTableView: UITableView!
    
    var listOfBuddyTasks: [Task] = [] {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfBuddyTasks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("buddyCell", forIndexPath: indexPath) as! BuddyTaskCell
        cell.buddyTaskLabel.text = self.listOfBuddyTasks[indexPath.row].title
        
        return cell
    }
}