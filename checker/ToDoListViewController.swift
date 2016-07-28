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
    @IBAction func unwindToToDoListViewController(segue: UIStoryboardSegue) { }
    
    var ref = FIRDatabaseReference()
    var currentUser = "superuser"//RealmHelper.getUser()
    var taskArray: [Task] = [] {
        didSet {
            self.taskTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        setTasksForUserFromFirebase()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
}

extension ToDoListViewController {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = self.taskTableView.dequeueReusableCellWithIdentifier("taskCell") as! MGSwipeTableCell!
        if cell == nil
        {
            cell = MGSwipeTableCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "taskCell")
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
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.cellForRowAtIndexPath(indexPath)?.reuseIdentifier == "taskCell" {
            if editingStyle == .Delete {
                //1
                //RealmHelper.deleteTask(taskArray[indexPath.row])
                //taskArray = RealmHelper.retrieveTasks()
            }
        }
    }
}

extension ToDoListViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTask" {
            
            let taskViewController = segue.destinationViewController as! TaskViewController
            let indexPath = taskTableView.indexPathForSelectedRow!
            taskViewController.taskToEdit = self.taskArray[indexPath.row]
            taskViewController.taskArray = self.taskArray
            
        } else if segue.identifier == "newTask" {
            
                        let taskViewController = segue.destinationViewController as! TaskViewController
                        let newTask = Task(title: "", descriptionText: "Description...", dueDate: NSDate())
            
                        taskViewController.isNewTask = true
                        taskViewController.taskToEdit = newTask
                        taskViewController.taskArray = self.taskArray
            
        }
    }
}

extension ToDoListViewController {
    
    func setTasksForUserFromFirebase() {
        
        ref.child("tasks").child(currentUser).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            // Get user value
            guard let tempListOfTasks = snapshot.value! as? [String: AnyObject] else {
                print(snapshot.value)
                return
            }
            
            self.taskArray = []
            for tempTask in tempListOfTasks {
                
                let title = tempTask.1["title"] as! String
                let descriptionText = tempTask.1["descriptionText"] as! String
                //let dueDate = tempTask.1["expirationDate"] as! String
                let task = Task(title: title, descriptionText: descriptionText, dueDate: NSDate())
                self.taskArray.append(task)
            }
            
            self.taskTableView.reloadData()
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
}