//
//  GlobalCode.swift
//  Buurt
//
//  Created by Martijn de Jong on 10-01-17.
//  Copyright © 2017 Martijn de Jong. All rights reserved.
//

import Foundation
import Firebase
import MapKit

struct currentInfo {
    static var mentions = Array<MentionItem>()
    static var user = Dictionary<String, String>()
    static var followlist = Array<String>()
    static var selectedMention =  Dictionary<String, Any>()
    static var uidNameDict = Dictionary<String, String>()
    static var uidPictureDict = Dictionary<String, String>()
}

extension Notification.Name {
    static let reload = Notification.Name("reload")
}

func updateMentions(selectedKey: String?) {
    print("UPDATEMENTIONS() EXECUTED")
    let ref = FIRDatabase.database().reference(withPath: "mentions")
    ref.child(currentInfo.user["postcode"]!).observe(.value, with: { snapshot in
        let rawData = snapshot.value as? NSDictionary
        currentInfo.mentions = []
        if rawData != nil {
            for item in rawData! {
                let mentionData = item.value as? NSDictionary
                print("MENTIONDATA", mentionData)
                if mentionData!["replies"] != nil {
                    print("REPLIES", (mentionData!["replies"] as! Array<Array<Any>>))
                    let mentionItem = MentionItem(titel: mentionData!["titel"] as! String, addedByUser: mentionData!["addedByUser"] as! String, category: mentionData!["category"] as! String, location: mentionData!["location"] as! Dictionary<String, String>, message: mentionData!["message"] as! String, timeStamp: mentionData!["timeStamp"] as! String, replies: mentionData!["replies"] as! Array<Array<Any>>, key: item.key as! String)
                    currentInfo.mentions.append(mentionItem)
                    if item.key as? String == selectedKey {
                        currentInfo.selectedMention = mentionItem.toAnyObject()
                    }
                }
                else {
                    let mentionItem = MentionItem(titel: mentionData!["titel"] as! String, addedByUser: mentionData!["addedByUser"] as! String, category: mentionData!["category"] as! String, location: mentionData!["location"] as! Dictionary<String, String>, message: mentionData!["message"] as! String, timeStamp: mentionData!["timeStamp"] as! String, key: item.key as! String)
                    currentInfo.mentions.append(mentionItem)
                    if item.key as? String == selectedKey {
                        currentInfo.selectedMention = mentionItem.toAnyObject()
                    }
                }
                
            }
        }
        currentInfo.mentions = currentInfo.mentions.reversed()
        NotificationCenter.default.post(name: .reload, object: nil)
    })
}

func updateCurrentUserInfo() {
    FIRDatabase.database().reference(withPath: "users").observe(.value, with: { snapshot in
        let userData = (snapshot.value as? NSDictionary)!
        for item in userData {
            let userDetails = item.value as? NSDictionary
            if item.key as! String == currentInfo.user["uid"]! {
                currentInfo.user["firstname"] = userDetails!["firstname"] as? String
                currentInfo.user["lastname"] = userDetails!["lastname"] as? String
                currentInfo.user["email"] = userDetails!["email"] as? String
                currentInfo.user["postcode"] = userDetails!["postcode"] as? String
                currentInfo.user["picture"] = userDetails!["picture"] as? String
                currentInfo.followlist = (userDetails!["followlist"] as? Array<String>)!
            }
        }
    })

}

func updateUserDict () {
    FIRDatabase.database().reference(withPath: "users").observe(.value, with: { snapshot in
        let userData = (snapshot.value as? NSDictionary)!
        for item in userData {
            let userDetails = item.value as? NSDictionary
            currentInfo.uidNameDict[item.key as! String] = "\(userDetails!["firstname"] as! String) \(userDetails!["lastname"] as! String)"
            currentInfo.uidPictureDict[item.key as! String] = userDetails!["picture"] as? String
        }
    })
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

func getLocation(longitude: CLLocationDegrees, latitude:CLLocationDegrees) -> String {
    let location = CLLocation(latitude: latitude, longitude: longitude)
    var returnLocation = String()
    CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
        print(location)
        
        if error != nil {
            print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
        }
        
        if (placemarks?.count)! > 0 {
            let pm = (placemarks?[0])! as CLPlacemark
            returnLocation = pm.name! as String
        }
            
        else {
            print("Couldn't find address")
        }
    })
    
    return returnLocation
    
}
