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
            saveTaskToFirebase()
            return true
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
            return true
        }
    }
    
    func saveTaskToFirebase() {
    
        if isNewTask {
            self.ref.child("tasks").child(currentUser!.username).childByAutoId().setValue(["title": self.taskTitleTextField.text!, "description": self.taskDescriptionTextField.text!, "dueDate": String(self.taskExpirationDatePicker.date)])
        } else {
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "save" {
            
            let toDoListViewController = segue.destinationViewController as! ToDoListViewController
            self.taskArray.append(Task(title: self.taskTitleTextField.text!, descriptionText: self.taskDescriptionTextField.text!, dueDate: self.taskExpirationDatePicker.date))
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
        let maxLength: Int = 16
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