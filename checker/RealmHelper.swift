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
    
    static func login(user: User) {
        let realm = try! Realm()
        try! realm.write() {
            realm.add(user)
        }
    }
    
    static func logout(user: User) {
        let realm = try! Realm()
        try! realm.write() {
            realm.delete(user)
        }
    }
    
    static func getUser() -> User {
        let realm = try! Realm()
        return Array(realm.objects(User))[0]
    }
    
}