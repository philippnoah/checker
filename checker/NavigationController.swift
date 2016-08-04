//
//  NavigationController.swift
//  checker
//
//  Created by Philipp Eibl on 8/2/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import Foundation
import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.tintColor = UIColor(red:0.47, green:0.75, blue:0.22, alpha:1.0)
    }

}