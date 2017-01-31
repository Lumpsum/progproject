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

let ref = FIRDatabase.database().reference(withPath: "mentions")

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

/// Fills currentInfo.mentions and currentInfo.selectedMention, only used as helpfunction of updateMentions().
private func fillMentionsArray(replies: Bool, mentionData: NSDictionary, mentionKey: String, selectedKey: String?) {
    if replies == false {
        let mentionItem = MentionItem(titel: mentionData["titel"] as! String, addedByUser: mentionData["addedByUser"] as! String, category: mentionData["category"] as! String, location: mentionData["location"] as! Dictionary<String, String>, message: mentionData["message"] as! String, timeStamp: mentionData["timeStamp"] as! String, replies: mentionData["replies"] as! Array<Array<Any>>, key: mentionKey)
        currentInfo.mentions.append(mentionItem)
        if mentionKey == selectedKey {
            currentInfo.selectedMention = mentionItem.toAnyObject()
        }
    }
    else {
        let mentionItem = MentionItem(titel: mentionData["titel"] as! String, addedByUser: mentionData["addedByUser"] as! String, category: mentionData["category"] as! String, location: mentionData["location"] as! Dictionary<String, String>, message: mentionData["message"] as! String, timeStamp: mentionData["timeStamp"] as! String, key: mentionKey)
        currentInfo.mentions.append(mentionItem)
        if mentionKey == selectedKey {
            currentInfo.selectedMention = mentionItem.toAnyObject()
        }
    }
}


/// Retrieve all mentions from the Firebase server for the current postal code and sets global variables.
func updateMentions(selectedKey: String?) {
    ref.child(currentInfo.user["postcode"]!).observe(.value, with: { snapshot in
        let rawData = snapshot.value as? NSDictionary
        currentInfo.mentions = []
        if rawData != nil {
            for item in rawData! {
                let mentionData = item.value as? NSDictionary
                if mentionData!["replies"] != nil {
                    fillMentionsArray(replies: false, mentionData: mentionData!, mentionKey: item.key as! String, selectedKey: selectedKey)
                }
                else {
                    fillMentionsArray(replies: true, mentionData: mentionData!, mentionKey: item.key as! String, selectedKey: selectedKey)
                }
            }
        }
        currentInfo.mentions = currentInfo.mentions.reversed()
        NotificationCenter.default.post(name: .reload, object: nil)
    })
}


/// Retrieve information of current user and stores it in currentInfo.user.
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


/// Retrieves information of all users and stores them in currrentInfo.uidNameDict. This is used to show names at the posts in the feed.
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


/// Calculates the timeinterval from the given timestamp till now. Returns in string to display at each mentions in the feed.
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
    else {
        let index = inputDate.index(inputDate.startIndex, offsetBy: 10)
        return inputDate.substring(to: index)
    }
    
}

///
func getLocation(longitude: CLLocationDegrees, latitude:CLLocationDegrees, completion: @escaping (_ locationName: String) -> Void) {
    let location = CLLocation(latitude: latitude, longitude: longitude)
    CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
        
        if error != nil {
            print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
        }
        
        if (placemarks?.count)! > 0 {
            let pm = (placemarks?[0])! as CLPlacemark
            
            var postalcode = pm.postalCode!
            let index = postalcode.index(postalcode.startIndex, offsetBy: 4)
            postalcode = postalcode.substring(to: index)
            print("CURRENT POSTAL CODE", postalcode)
            
            if postalcode == currentInfo.user["postcode"] {
                completion((pm.name! as String))
            }
            else {
                print("NOT IN POSTCODE REGION")
                completion("invalid")
            }
        }
            
        else {
            print("Couldn't find address")
        }
    })
}
