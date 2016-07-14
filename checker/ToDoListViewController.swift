//
//  File.swift
//  checker
//
//  Created by Philipp Eibl on 7/12/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import UIKit
import Firebase

class ToDoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var toDoListTitleLabel: UILabel!
    
    @IBOutlet var taskTableView: UITableView!

    var taskArray = [Task]()
    var tempArray = [Task]()
    let deviceID = UIDevice.currentDevice().identifierForVendor!.UUIDString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        taskTableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        taskTableView.reloadData()

    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : Cell
        
        if indexPath.row < taskArray.count {
            cell = tableView.dequeueReusableCellWithIdentifier("taskCell", forIndexPath: indexPath) as! TaskCell
            cell.taskLabel.text = self.taskArray[indexPath.row].title
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("newTaskCell", forIndexPath: indexPath) as! NewTaskCell
        }
        
        return cell as! UITableViewCell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTask" {
            
            let taskViewController = segue.destinationViewController as! TaskViewController
            let indexPath = taskTableView.indexPathForSelectedRow!
            taskViewController.taskToEdit = self.taskArray[indexPath.row]
            taskViewController.taskArray = self.taskArray
            
        } else if segue.identifier == "newTask" {
            let taskViewController = segue.destinationViewController as! TaskViewController
            let newTask = Task(title: "Title", description: "Description...", expirationDate: NSDate())
            taskViewController.taskToEdit = newTask
            taskViewController.taskArray = self.taskArray
        }
    }
    
    func changeTaskArray(task: Task) {
        taskArray.append(task)
    }
    
}