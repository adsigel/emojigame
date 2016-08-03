//
//  Users.swift
//  emojigame
//
//  Created by Adam Sigel on 8/3/16.
//  Copyright © 2016 Adam Sigel. All rights reserved.
//

import Foundation
import Firebase

struct User {
    let uid: Int
    let displayName: String
    let email: String
    let score: Int
    
    // Initialize from Firebase
    init(authData: FIRUser) {
        uid = authData.uid as! Int
        email = authData.email!
        displayName = authData.displayName!
        score = 0
    }
    
    // Initialize from arbitrary data
    init(uid: Int, email: String, displayName: String, score: Int) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
        self.score = score
    }
    
    func toAnyObjectUser() -> AnyObject {
        return [
            "uid": uid,
            "displayName": displayName,
            "email": email,
            "score": score
        ]
    }
}