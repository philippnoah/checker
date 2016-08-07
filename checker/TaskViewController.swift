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
    
    var indexForTaskToEdit: Int!
    var stringID: String!
    var taskArray: [Task] = []
    var taskToEdit: Task!
    var isNewTask = false
    var textViewEdited = false
    var ref = FIRDatabaseReference()
    var currentUser = RealmHelper.getUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        textFieldAndtextViewSetUp()
        
        setTasksForUserFromFirebase()
        navigationController?.navigationBar.tintColor = UIColor(red:0.47, green:0.75, blue:0.22, alpha:1.0)
        
        let titleTextFieldPadding: UIView = UIView(frame: CGRectMake(0, 0, 10, 0))
        taskTitleTextField.leftView = titleTextFieldPadding
        taskTitleTextField.leftViewMode = .Always
    }
}

extension TaskViewController {
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if self.taskTitleTextField.text == "" || self.taskDescriptionTextField.text == "" {
         return false
        }
        
        if identifier == "save" {
            saveTask()
            return true
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
            return true
        }
    }
    
    func saveTask() {
    
        if isNewTask {
            self.ref.child("tasks").child(currentUser!.username).childByAutoId().setValue([
                "title": self.taskTitleTextField.text!,
                "description": self.taskDescriptionTextField.text!,
                "dueDate": String(self.taskExpirationDatePicker.date)
                ])
            
                self.taskArray.append(Task(title: self.taskTitleTextField.text!, descriptionText: self.taskDescriptionTextField.text!, dueDate: self.taskExpirationDatePicker.date))
        } else {
            self.ref.child("tasks").child(currentUser!.username).child(self.stringID).setValue([
                "title": self.taskTitleTextField.text!,
                "description": self.taskDescriptionTextField.text!,
                "dueDate": String(self.taskExpirationDatePicker.date)
                ])
            
            self.taskArray[indexForTaskToEdit] = Task(title: self.taskTitleTextField.text!, descriptionText: self.taskDescriptionTextField.text!, dueDate: self.taskExpirationDatePicker.date)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "save" {
            
            let toDoListViewController = segue.destinationViewController as! ToDoListViewController
            toDoListViewController.taskArray = self.taskArray
            toDoListViewController.taskTableView.reloadData()
        } else {
            print(self)
        }
    }
}

extension TaskViewController {

    func textViewDidBeginEditing(textView: UITextView) {
        if textViewEdited == false {
            taskDescriptionTextField.text = ""
            textViewEdited = true
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let maxLength: Int = 100
        return textView.text!.characters.count + (text.characters.count - range.length) <= maxLength
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let maxLength: Int = 25
        return textField.text!.characters.count + (string.characters.count - range.length) <= maxLength
    }
    
    func textFieldAndtextViewSetUp() {
        taskDescriptionTextField.delegate = self
        taskTitleTextField.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        taskDescriptionTextField.enablesReturnKeyAutomatically = true
        taskDescriptionTextField.textContainer.maximumNumberOfLines = 1
        if taskToEdit == nil {
            taskToEdit = Task(title: "Title", descriptionText: "Description", dueDate: NSDate())
        }
        self.taskExpirationDatePicker.date = taskToEdit.dueDate
        self.taskTitleTextField.text = taskToEdit.title
        self.taskDescriptionTextField.text = taskToEdit.descriptionText
    }
}

extension TaskViewController {
    
    func setTasksForUserFromFirebase() {
        if isNewTask {return}
        
        ref.child("tasks").child(currentUser!.username).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            // Get user value
            guard let tempListOfTasks = snapshot.value! as? [String: AnyObject] else {return}
            
            for tempTask in tempListOfTasks {
                
                if tempTask.1["title"] as! String == self.taskToEdit.title {
                    self.stringID = tempTask.0
                }
                
            }
            
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}