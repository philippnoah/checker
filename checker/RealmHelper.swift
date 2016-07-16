//
//  RealmHelper.swift
//  checker
//
//  Created by Philipp Eibl on 6/24/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHelper {
    //static methods will go here
    
    static func addTask(task: Task) {
        let realm = try! Realm()
        try! realm.write() {
            realm.add(task)
        }
    }
    
    static func deleteTask(task: Task) {
        let realm = try! Realm()
        try! realm.write() {
            realm.delete(task)
        }
    }
    
    static func updateTask(taskToBeUpdated: Task, newTask: Task) {
        let realm = try! Realm()
        try! realm.write() {
            taskToBeUpdated.title = newTask.title
            taskToBeUpdated.descriptionText = newTask.descriptionText
            taskToBeUpdated.expirationDate = newTask.expirationDate
        }
    }
    
    static func retrieveTasks() -> Results<Task> {
        let realm = try! Realm()
        return realm.objects(Task)//.sorted("modificationTime", ascending: false)
    }
}