//
//  User.swift
//  Buurt
//
//  Created by Martijn de Jong on 12-01-17.
//  Copyright © 2017 Martijn de Jong. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    let firstname: String
    let lastname: String
    let postcode: String
    let followlist: Array<String>?
    
    init(uid: String, email: String, firstname: String, lastname: String, postcode: String, followlist: Array<String>?) {
        self.uid = uid
        self.email = email
        self.firstname = firstname
        self.lastname = lastname
        self.postcode = postcode
        self.followlist = followlist
    }
    
    func toAnyObject() -> Dictionary<String, Any> {
        return [
            "email": email,
            "firstname": firstname,
            "lastname": lastname,
            "postcode": postcode,
            "followlist": followlist!]
    }
    
}
