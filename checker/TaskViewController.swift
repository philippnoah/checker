//
//  TaskViewController.swift
//  checker
//
//  Created by Philipp Eibl on 7/13/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var taskTitleTextField: UITextField!
    
    @IBOutlet var taskDescriptionTextField: UITextView!
    
    var taskToEdit: Task!
    var taskArray: [Task]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        self.taskTitleTextField.text = taskToEdit.title
        self.taskDescriptionTextField.text = taskToEdit.description
        if taskToEdit != nil {
        } else {
            taskToEdit = Task(title: "Title", description: "Description...")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "save" {
            if taskTitleTextField.text != "" && taskDescriptionTextField.text != "" {
                if taskTitleTextField.text != taskToEdit.title {
            
                let toDoListViewController = segue.destinationViewController as! ToDoListViewController
                let newTask = Task(title: taskTitleTextField.text!, description: taskDescriptionTextField.text!)
                self.taskArray.append(newTask)
                toDoListViewController.taskArray = self.taskArray
                    
                } else {
                    let toDoListViewController = segue.destinationViewController as! ToDoListViewController
                    toDoListViewController.taskArray = self.taskArray
                }
            }
        } else {
            let toDoListViewController = segue.destinationViewController as! ToDoListViewController
            toDoListViewController.taskArray = self.taskArray
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        taskDescriptionTextField.text = ""
    }
    
}