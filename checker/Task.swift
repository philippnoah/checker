//
//  Task.swift
//  checker
//
//  Created by Philipp Eibl on 7/13/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import Foundation

class Task {
    
    var title: String = ""
    var descriptionText: String = ""
    var dueDate: NSDate = NSDate()
    
    init(title: String, descriptionText: String, dueDate: NSDate) {
        
        self.title = title
        self.descriptionText = descriptionText
        self.dueDate = dueDate
        
    }
    
}