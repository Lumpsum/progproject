//
//  GlobalCode.swift
//  Buurt
//
//  Created by Martijn de Jong on 10-01-17.
//  Copyright © 2017 Martijn de Jong. All rights reserved.
//

import Foundation
import Firebase

let ref = FIRDatabase.database().reference(withPath: "mentions")

struct currentInfo {
    static var postcode = "1033"
    static var mentions = Array<MentionItem>()
    static var uid = String()
    static var userName = String()
    static var selectedMention =  Dictionary<String, Any>()
    static var uidNameDict = Dictionary<String, String>()
    static var location = String()
}

func getTimeDifference(inputDate: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
    let date = dateFormatter.date(from: inputDate)
    let interval = NSDate().timeIntervalSince(date!)
    
    if interval < 60 {
        return "Nu"
    }
    else if interval < 3600 {
        return "\(Int(interval/60)) minuten"
    }
    else if interval < 86400 {
        return "\(Int(interval/3600)) uur"
    }
    else if interval < 604800 {
        return "Deze week"
    }
    else {
        return "\(Int(interval/604800)) weken"
    }
    
}
