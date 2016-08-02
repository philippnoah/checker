//
//  Subclass.swift
//  checker
//
//  Created by Philipp Eibl on 8/1/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import Foundation
import UIKit

class UILongNavigationBar: UINavigationBar {
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        let originalSize = super.sizeThatFits(size)
        return CGSizeMake(originalSize.width, originalSize.height + 0)
    }
    
}