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
    static var postcode = "1033"
    static var mentions = Array<MentionItem>()
    static var uid = String()
    static var user = Dictionary<String, String>()
    static var followlist = Array<String>()
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
}

func updateCurrentUserInfo() {
    FIRDatabase.database().reference(withPath: "users").observe(.value, with: { snapshot in
        let userData = (snapshot.value as? NSDictionary)!
        if currentInfo.user["firstname"] != nil {
            return
        } else {
            print("TESTPRINT1")
            for item in userData {
                print("TESTPRINT2")
                let userDetails = item.value as? NSDictionary
                print("KEY1", item.key as! String)
                print("KEY2", currentInfo.user["uid"]!)
                if item.key as! String == currentInfo.user["uid"]! {
                    print("TESTPRINT3")
                    currentInfo.user["firstname"] = userDetails!["firstname"] as? String
                    currentInfo.user["lastname"] = userDetails!["lastname"] as? String
                    currentInfo.user["email"] = userDetails!["email"] as? String
                    currentInfo.user["postcode"] = userDetails!["postcode"] as? String
                    print(currentInfo.user)
                }
            }
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
    
    CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
        print(location)
        
        if error != nil {
            print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
        }
        
        if (placemarks?.count)! > 0 {
            let pm = (placemarks?[0])! as CLPlacemark
            //print("POSTCODE:", pm.postalCode, pm.thoroughfare)
            currentInfo.location = pm.name! as String
        }
            
        else {
            print("Couldn't find address")
        }
    })
    
    return currentInfo.location
    
}
