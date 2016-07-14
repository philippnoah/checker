//
//  Task.swift
//  checker
//
//  Created by Philipp Eibl on 7/13/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import Foundation

class Task {
    
    var title: String
    var description: String
    var expirationDate: NSDate
    
    init(title: String, description: String, expirationDate: NSDate) {
        self.title = title
        self.description = description
        self.expirationDate = expirationDate
    }
    
}