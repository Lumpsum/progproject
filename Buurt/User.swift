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
    
    //init(authData: FIRUser, firstname: String, lastname: String, postcode: String) {
    //    uid = authData.uid
    //    email = authData.email!
    //    self.firstname = firstname
    //    self.lastname = lastname
    //    self.postcode = postcode
    //}
    
    init(uid: String, email: String, firstname: String, lastname: String, postcode: String) {
        self.uid = uid
        self.email = email
        self.firstname = firstname
        self.lastname = lastname
        self.postcode = postcode
    }
    
    func toAnyObject() -> Dictionary<String, Any> {
        return [
            "email": email,
            "firstname": firstname,
            "lastname": lastname,
            "postcode": postcode ]
    }
    
}
