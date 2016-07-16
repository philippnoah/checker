//
//  TaskViewController.swift
//  checker
//
//  Created by Philipp Eibl on 7/13/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

class TaskViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var taskExpirationDatePicker: UIDatePicker!
    @IBOutlet var taskTitleTextField: UITextField!
    @IBOutlet var taskDescriptionTextField: UITextView!
    
    
    var taskArray: Results<Task>!
    var taskToEdit: Task!
    var isNewTask = false
    var textViewEdited = false
    let realm = try! Realm()
    var ref = FIRDatabaseReference()
    var user = "thedan"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ref = FIRDatabase.database().reference()
        self.navigationController?.navigationBarHidden = false
        taskDescriptionTextField.delegate = self
        taskTitleTextField.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        taskDescriptionTextField.enablesReturnKeyAutomatically = true

        self.taskExpirationDatePicker.date = taskToEdit.expirationDate
        self.taskTitleTextField.text = taskToEdit.title
        self.taskDescriptionTextField.text = taskToEdit.descriptionText
        
        if taskToEdit != nil {
        } else {
            taskToEdit = Task()
            taskToEdit.title = "Title"
            taskToEdit.descriptionText = "Description"
            taskToEdit.expirationDate = NSDate()
        }
        taskDescriptionTextField.textContainer.maximumNumberOfLines = 1
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != "ssave" {
            
            if taskTitleTextField.text != "" && taskDescriptionTextField.text != "" {
                
                let newTask = Task()
                newTask.title = taskTitleTextField.text!
                newTask.descriptionText = taskDescriptionTextField.text!
                newTask.expirationDate = taskExpirationDatePicker.date
                
                if isNewTask == true {
                    
                    RealmHelper.addTask(newTask)
                    
                } else {
                    
                    RealmHelper.updateTask(taskToEdit, newTask: newTask)
                    
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
            textViewEdited = true
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let maxLength: Int = 100
        //If the text is larger than the maxtext, the return is false
        
        // Swift 2.0
        return textView.text!.characters.count + (text.characters.count - range.length) <= maxLength
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let maxLength: Int = 16
        //If the text is larger than the maxtext, the return is false
        
        // Swift 2.0
        return textField.text!.characters.count + (string.characters.count - range.length) <= maxLength
    }
    
    func saveToFirebase() {
        self.ref.child("users").child(user).setValue(["username": user])
    }
    
}