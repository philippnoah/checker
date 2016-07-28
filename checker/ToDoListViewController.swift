//
//  File.swift
//  checker
//
//  Created by Philipp Eibl on 7/12/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import UIKit
import Firebase
import MGSwipeTableCell

class ToDoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var toDoListTitleLabel: UILabel!
    @IBOutlet var taskTableView: UITableView!
    
    var ref = FIRDatabaseReference()
    var taskArray: [Task] = [Task(title: "test", descriptionText: "test", dueDate: NSDate())]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return taskArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let reuseIdentifier = "taskCell"
        var cell = self.taskTableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! MGSwipeTableCell!
        if cell == nil
        {
            cell = MGSwipeTableCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        cell.textLabel!.text = taskArray[indexPath.row].title
        
        let leftSwipeButton = MGSwipeButton(title: "Delete", backgroundColor: UIColor.redColor(), callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            print("left button pressed")
            return true
        })
        
        let rightSwipeButton = MGSwipeButton(title: "Done", backgroundColor: UIColor.greenColor(), callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            print("right button pressed")
            return true
        })
        
        //configure left buttons
        cell.leftButtons = [leftSwipeButton]
        cell.leftSwipeSettings.transition = MGSwipeTransition.Static
        
        //configure right buttons
        cell.rightButtons = [rightSwipeButton]
        cell.rightSwipeSettings.transition = MGSwipeTransition.Drag
        
        return cell
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTask" {
            
//            let taskViewController = segue.destinationViewController as! TaskViewController
//            let indexPath = taskTableView.indexPathForSelectedRow!
//            taskViewController.taskToEdit = self.taskArray[indexPath.row]
//            taskViewController.taskArray = self.taskArray
            
        } else if segue.identifier == "newTask" {
            
//            let taskViewController = segue.destinationViewController as! TaskViewController
//            let newTask = Task(title: "", descriptionText: "Description...", dueDate: NSDate())
//            
//            taskViewController.isNewTask = true
//            taskViewController.taskToEdit = newTask
//            taskViewController.taskArray = self.taskArray
            
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.cellForRowAtIndexPath(indexPath)?.reuseIdentifier == "taskCell" {
            if editingStyle == .Delete {
                //1
                //RealmHelper.deleteTask(taskArray[indexPath.row])
                //taskArray = RealmHelper.retrieveTasks()
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