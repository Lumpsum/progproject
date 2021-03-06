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


/// Retrieve all mentions from the Firebase server for the current postal code and sets global variables.
func updateMentions(selectedKey: String?) {
    ref.child(currentInfo.user["postcode"]!).queryOrdered(byChild: "timeStamp").observe(.value, with: { snapshot in
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
        NotificationCenter.default.post(name: .reload, object: nil)
    })
}


/// Helpfunction of updateMentions(). Fills currentInfo.mentions and currentInfo.selectedMention.
private func fillMentionsArray(replies: Bool, mentionData: NSDictionary, mentionKey: String, selectedKey: String?) {
    if replies == false {
        let mentionItem = MentionItem(titel: mentionData["titel"] as! String, addedByUser: mentionData["addedByUser"] as! String, category: mentionData["category"] as! String, location: mentionData["location"] as! Dictionary<String, String>, message: mentionData["message"] as! String, timeStamp: mentionData["timeStamp"] as! String, replies: mentionData["replies"] as! Array<Array<String>>, key: mentionKey)
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
func updateUserDict() {
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
    let interval = NSDate().timeIntervalSince(NSDate(timeIntervalSince1970: Double(inputDate)!) as Date)
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: NSDate(timeIntervalSince1970: Double(inputDate)!) as Date)
        return  dateString
    }
    
}


/// Sets profilepicture for given pictureHolder from a given picture url and uid.
func setProfilePictures(pictureUrl: String?, pictureHolder: UIImageView, userid: String) {
    if pictureUrl != nil && pictureUrl != "" {
        pictureHolder.loadImagesWithCache(urlstring: pictureUrl!, uid: userid)
        print("TESTPRINT HIER")
        pictureHolder.layer.cornerRadius = pictureHolder.frame.size.width / 2
        pictureHolder.clipsToBounds = true
    }
}

/// Centers a mapview for the given location with the given radius.
func centerMapOnLocation(location: CLLocation, regionRadius: CLLocationDistance, map: MKMapView) {
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
    map.setRegion(coordinateRegion, animated: true)
}

/// Enables menubutton in navigationbar.
func setMenuButton(controller: UIViewController, button: UIBarButtonItem) {
    if controller.revealViewController() != nil {
        button.target = controller.revealViewController()
        button.action = #selector(SWRevealViewController.revealToggle(_:))
        controller.view.addGestureRecognizer(controller.revealViewController().panGestureRecognizer())
    }
}
