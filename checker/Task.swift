//
//  Task.swift
//  checker
//
//  Created by Philipp Eibl on 7/13/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import Foundation
import RealmSwift


class Task: Object {
    
    dynamic var title: String = ""
    dynamic var descriptionText: String = ""
    dynamic var expirationDate: NSDate = NSDate()
    
}