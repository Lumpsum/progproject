//
//  MentionItem.swift
//  Buurt
//
//  Created by Martijn de Jong on 10-01-17.
//  Copyright © 2017 Martijn de Jong. All rights reserved.
//

import Foundation
import Firebase

struct MentionItem {
    
    let key: String
    let titel: String
    let category: String
    let addedByUser: String
    var location: Dictionary<String, String>
    var message: String
    var timeStamp: String
    var replies: Array<Array<String>>
    let ref: FIRDatabaseReference?
    
    init(titel: String, addedByUser: String, category: String, location: Dictionary<String, String>, message: String, timeStamp: String, replies: Array<Array<String>> = [[]], key: String = "") {
        self.key = key
        self.titel = titel
        self.category = category
        self.addedByUser = addedByUser
        self.location = location
        self.message = message
        self.timeStamp = timeStamp
        self.replies = replies
        self.ref = nil
    }
    
    func toAnyObject() -> Dictionary<String, Any> {
        return [
            "key": key,
            "titel": titel,
            "category": category,
            "addedByUser": addedByUser,
            "location": location,
            "message": message,
            "timeStamp": timeStamp,
            "replies": replies
        ]
    }
    
}
