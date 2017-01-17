//
//  GlobalCode.swift
//  Buurt
//
//  Created by Martijn de Jong on 10-01-17.
//  Copyright © 2017 Martijn de Jong. All rights reserved.
//

import Foundation
import Firebase

struct currentInfo {
    static var postcode = "1033"
    static var mentions = Array<MentionItem>()
    static var uid = String()
    static var userName = String()
    static var selectedMention =  Dictionary<String, Any>()
    static var uidNameDict = Dictionary<String, String>()
    static var location = String()
}

func updateMentions(selectedKey: String?) {
    let ref = FIRDatabase.database().reference(withPath: "mentions")
    ref.child(currentInfo.postcode).observe(.value, with: { snapshot in
        let rawData = snapshot.value as? NSDictionary
        currentInfo.mentions = []
        if rawData != nil {
            for item in rawData! {
                let mentionData = item.value as? NSDictionary
                let mentionItem = MentionItem(titel: mentionData!["titel"] as! String, addedByUser: mentionData!["addedByUser"] as! String, category: mentionData!["category"] as! String, location: mentionData!["location"] as! Dictionary<String, String>, message: mentionData!["message"] as! String, timeStamp: mentionData!["timeStamp"] as! String, replies: mentionData!["replies"] as! Array<Array<Any>>, key: item.key as! String)
                currentInfo.mentions.append(mentionItem)
                if item.key as? String == selectedKey {
                    currentInfo.selectedMention = mentionItem.toAnyObject()
                }
            }
        }
    })
    print("TEST", currentInfo.selectedMention)
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
