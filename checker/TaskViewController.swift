//
//  TaskViewController.swift
//  checker
//
//  Created by Philipp Eibl on 7/13/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var taskExpirationDatePicker: UIDatePicker!
    @IBOutlet var taskTitleTextField: UITextField!
    @IBOutlet var taskDescriptionTextField: UITextView!
    
    var taskToEdit: Task!
    var taskArray: [Task]!
    var textViewEdited = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        taskDescriptionTextField.delegate = self
        taskTitleTextField.delegate = self

        self.taskExpirationDatePicker.date = taskToEdit.expirationDate
        self.taskTitleTextField.text = taskToEdit.title
        self.taskDescriptionTextField.text = taskToEdit.description
        if taskToEdit != nil {
        } else {
            taskToEdit = Task(title: "Title", description: "Description...", expirationDate: NSDate())
        }
        taskDescriptionTextField.textContainer.maximumNumberOfLines = 1
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "save" {
            if taskTitleTextField.text != "" && taskDescriptionTextField.text != "" {
                if taskTitleTextField.text != taskToEdit.title {
            
                let toDoListViewController = segue.destinationViewController as! ToDoListViewController
                    let newTask = Task(title: taskTitleTextField.text!, description: taskDescriptionTextField.text!, expirationDate: taskExpirationDatePicker.date)
                self.taskArray.append(newTask)
                toDoListViewController.taskArray = self.taskArray
                    print(taskExpirationDatePicker.date)
                                        
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
        if textViewEdited == false {
        taskDescriptionTextField.text = ""
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let maxLength: Int = 100
        //If the text is larger than the maxtext, the return is false
        
        // Swift 2.0
        return textView.text.characters.count + (text.characters.count - range.length) <= maxLength
    }
}