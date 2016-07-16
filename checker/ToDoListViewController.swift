//
//  File.swift
//  checker
//
//  Created by Philipp Eibl on 7/12/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class ToDoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var toDoListTitleLabel: UILabel!
    
    @IBOutlet var taskTableView: UITableView!
    
    let realm = try! Realm()
    
    var ref = FIRDatabaseReference()
    
    var taskArray: Results<Task>! {
        didSet {
            taskTableView.reloadData()
        }
    }
    
    let deviceID = UIDevice.currentDevice().identifierForVendor!.UUIDString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        taskArray = RealmHelper.retrieveTasks()
        self.ref = FIRDatabase.database().reference()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
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
            let newTask = Task()
            newTask.title = ""
            newTask.descriptionText = "Description..."
            newTask.expirationDate = NSDate()
            
            taskViewController.isNewTask = true
            taskViewController.taskToEdit = newTask
            taskViewController.taskArray = self.taskArray
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if indexPath.row == taskArray.count {
            return .None
        }
        
        return .Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.cellForRowAtIndexPath(indexPath)?.reuseIdentifier == "taskCell" {
            if editingStyle == .Delete {
                //1
                RealmHelper.deleteTask(taskArray[indexPath.row])
                taskArray = RealmHelper.retrieveTasks()
            }
        }
    }
    
    func compareDataWithFirebase() {
        ref.child("tasks").child("").observeSingleEventOfType(.Value, withBlock: {
            (snapshot) in

                print(snapshot)
                
        }) {
            (error) in
            print(error.localizedDescription)
        }
    }
    
    
}