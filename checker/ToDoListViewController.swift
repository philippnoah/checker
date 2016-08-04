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
    @IBOutlet var addButton: UIBarButtonItem!
    
    var ref = FIRDatabaseReference()
    var currentUser = RealmHelper.getUser()
    var completedTaskArray: [Task] = []
    var taskArray: [Task] = [] {
        didSet {
            self.taskTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        self.setUpUI()
        self.taskTableView.tableFooterView = UIView(frame: CGRectZero)
        setTasksForUserFromFirebase()
        setCompletedTasksForUserFromFirebase()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = true
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBarHidden = false
    }
    
    func setUpUI() {
        
        self.taskTableView.layoutMargins = UIEdgeInsetsZero
        self.taskTableView.separatorInset = UIEdgeInsetsZero
        self.addButton.tintColor = UIColor(red:0.47, green:0.75, blue:0.22, alpha:1.0)
    }
}

extension ToDoListViewController {
    
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
            self.removeTaskFromFirebase(indexPath.row)
            return true
        })
        
        let rightSwipeButton = MGSwipeButton(title: "Done", backgroundColor: UIColor.greenColor(), callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            self.completedTask(indexPath.row)
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
        
        ref.child("tasks").child(currentUser!.username).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            // Get user value
            guard let tempListOfTasks = snapshot.value! as? [String: AnyObject] else {return}
            
            self.taskArray = []
            for tempTask in tempListOfTasks {
                
                
                    let title = tempTask.1["title"] as! String
                    let descriptionText = tempTask.1["description"] as! String
                    //let dueDate = tempTask.1["dueDate"] as! String
                    let task = Task(title: title, descriptionText: descriptionText, dueDate: NSDate())
                    self.taskArray.append(task)
                
            }
            
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func setCompletedTasksForUserFromFirebase() {
        
        ref.child("completedTasks").child(currentUser!.username).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            guard let tempListOfTasks = snapshot.value! as? [String: AnyObject] else {return}
            self.completedTaskArray = []
            for tempTask in tempListOfTasks {
                
                    let title = tempTask.1["title"] as! String
                    let descriptionText = tempTask.1["description"] as! String
                    //let dueDate = tempTask.1["dueDate"] as! String
                    let task = Task(title: title, descriptionText: descriptionText, dueDate: NSDate())
                    self.completedTaskArray.append(task)
                    
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func removeTaskFromFirebase(taskIndex: Int) {
        self.taskArray.removeAtIndex(taskIndex)
        self.ref.child("tasks").child(currentUser!.username).setValue(nil)
        for task in self.taskArray {
            self.ref.child("tasks").child(currentUser!.username).childByAutoId().setValue(["title": task.title, "description": task.descriptionText, "dueDate": String(task.dueDate)])
        }
    }

    func completedTask(taskIndex: Int) {
        self.completedTaskArray.append(taskArray[taskIndex])
        removeTaskFromFirebase(taskIndex)
        self.ref.child("completedTasks").child(currentUser!.username).setValue(nil)
        for task in self.completedTaskArray {
            self.ref.child("completedTasks").child(currentUser!.username).childByAutoId().setValue(["title": task.title, "description": task.descriptionText])
        }
    }
}