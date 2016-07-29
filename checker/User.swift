//
//  User.swift
//  checker
//
//  Created by Philipp Eibl on 7/15/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//
import RealmSwift

class User: Object {
    
    dynamic var username: String!
    dynamic var password: String!
    dynamic var buddy: String?

}