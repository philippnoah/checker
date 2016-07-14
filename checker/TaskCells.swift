//
//  TaskCell.swift
//  checker
//
//  Created by Philipp Eibl on 7/12/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import UIKit

protocol Cell {
    
    var taskLabel: UILabel! {get}
    
}

class TaskCell: UITableViewCell, Cell {
    
    @IBOutlet var taskLabel: UILabel!

}

class NewTaskCell: UITableViewCell, Cell {
    
    @IBOutlet var taskLabel: UILabel!
    
}