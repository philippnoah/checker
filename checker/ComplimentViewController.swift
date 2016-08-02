//
//  ComplimentViewController.swift
//  
//
//  Created by Philipp Eibl on 7/29/16.
//
//

import Foundation
import UIKit
import CCMPopup
import Firebase

class ComplimentViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var complimentTitleLabel: UILabel!
    @IBOutlet var complimentPickerView: UIPickerView!
    @IBAction func sendComplimentBuddy(sender: UIButton) {
        sendCompliment()
        removeTaskFromCompletedTasks()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var ref = FIRDatabaseReference()
    var currentUser: User!
    var taskToDelete: String!
    var indexForTaskToDelete: Int!
    var complimentsArray = ["Good job!", "Well done!", "Gotta catch'em all!"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        self.currentUser = RealmHelper.getUser()
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.layer.cornerRadius = 5
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    func sendCompliment() {
        self.ref.child("compliments").childByAutoId().setValue(["compliment": self.complimentPickerView.selectedRowInComponent(0).description, "toUser": currentUser.buddy!])
    }
    
    func removeTaskFromCompletedTasks() {
        
        ref.child("completedTasks").child(currentUser.buddy!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            // Get user value
            guard let tempListOfTasks = snapshot.value! as? [String: AnyObject] else {print("nope");return}
            
            for tempTask in tempListOfTasks {
                                
                if tempTask.1["title"] as! String == self.taskToDelete {
                
                    self.ref.child("completedTasks").child(self.currentUser.buddy!)
                        .child(tempTask.0)
                        .setValue(nil)
                    
                }
            }
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
}

extension ComplimentViewController {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return complimentsArray.count
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        return NSAttributedString(string: complimentsArray[row])
    }
}

extension ComplimentViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let buddiesViewController = segue.destinationViewController as! BuddiesViewController
        buddiesViewController.buddyTaskArray.removeAtIndex(self.indexForTaskToDelete)
        buddiesViewController.buddyTasksListTableView.reloadData()
    }
}
