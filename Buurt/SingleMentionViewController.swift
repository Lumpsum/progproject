//
//  SingleMentionViewController.swift
//  Buurt
//
//  Keyboard functions created by David Sanford
//  http://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift
//
//  Created by Martijn de Jong on 13-01-17.
//  Copyright © 2017 Martijn de Jong. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class SingleMentionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let ref = FIRDatabase.database().reference(withPath: "mentions")
    let userRef = FIRDatabase.database().reference(withPath: "users").child(currentInfo.user["uid"]!)
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var profilePictureHolder: UIImageView!
    @IBOutlet var messageField: UITextView!
    @IBOutlet var commentField: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var followIcon: UIBarButtonItem!
    
    @IBAction func CommentButtonDidTouch(_ sender: Any) {
        updateMentions(selectedKey: currentInfo.selectedMention["key"] as? String)
        saveComment()
        updateMentions(selectedKey: currentInfo.selectedMention["key"] as? String)
        self.tableView.reloadData()

    }
    
    @IBAction func FollowButtonDidTouch(_ sender: Any) {
        if currentInfo.followlist.contains(currentInfo.selectedMention["key"] as! String) == false {
            currentInfo.followlist.append(currentInfo.selectedMention["key"] as! String)
            userRef.updateChildValues(["followlist": currentInfo.followlist])
            navigationItem.rightBarButtonItem?.tintColor = UIColor.green
        }
        else if currentInfo.followlist.contains(currentInfo.selectedMention["key"] as! String) {
            let indexToRemove = currentInfo.followlist.index(of: currentInfo.selectedMention["key"] as! String)
            currentInfo.followlist.remove(at: indexToRemove!)
            userRef.updateChildValues(["followlist": currentInfo.followlist])
            navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        self.title = currentInfo.selectedMention["titel"] as! String?
        nameLabel.text = currentInfo.uidNameDict[(currentInfo.selectedMention["addedByUser"] as! String?)!]
        timeLabel.text = getTimeDifference(inputDate: (currentInfo.selectedMention["timeStamp"] as! String?)!)
        messageField.text = currentInfo.selectedMention["message"] as! String?
        setProfilePictures(pictureUrl: currentInfo.uidPictureDict[(currentInfo.selectedMention["addedByUser"] as! String?)!]!, pictureHolder: self.profilePictureHolder, userid: ((currentInfo.selectedMention["addedByUser"] as! String?)!))
        setMapForMention()
        
        if currentInfo.followlist.contains(currentInfo.selectedMention["key"] as! String) {
            followIcon.tintColor = UIColor.green
        }
        
        // MARK: Notifications to make sure the screen moves up if keyboards shows.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Sets map and annotation for a selected mention in the SingleMentionViewController.
    private func setMapForMention() {
        let dbLocation = currentInfo.selectedMention["location"] as! Dictionary<String, String>
        let initialLocation = CLLocation(latitude: Double(dbLocation["latitude"]!)!, longitude: Double(dbLocation["longitude"]!)!)
        centerMapOnLocation(location: initialLocation, regionRadius: 100, map: mapView)
        
        let mapPointer = MapPointer(title: (currentInfo.selectedMention["titel"] as! String?)!, coordinate: CLLocationCoordinate2D(latitude: Double(dbLocation["latitude"]!)!, longitude: Double(dbLocation["longitude"]!)!))
        mapView.addAnnotation(mapPointer)
    }

    /// Appends new comment to commentlist and uploads to Firebase.
    private func saveComment() {
        let commentRef = ref.child(currentInfo.user["postcode"]!).child((currentInfo.selectedMention["key"] as! String))
        var tempComments = currentInfo.selectedMention["replies"] as! Array<Array<String>>
        if tempComments[0].count == 0 {
            tempComments = Array<Array<String>>()
        }
        tempComments.append([currentInfo.user["uid"]!, "\(NSDate())", commentField.text!])
        commentRef.updateChildValues(["replies": tempComments])
        // The next line is needed to make sure the reply shows directly in the table view.
        currentInfo.selectedMention["replies"] = tempComments
        self.commentField.text = ""
        dismissKeyboard()
    }
    
    // MARK: Keyboard functions.
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    // MARK: Tableview methods.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (currentInfo.selectedMention["replies"] as! Array<Array<String>>)[0].isEmpty == false {
            return (currentInfo.selectedMention["replies"] as! Array<Array<String>>).count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentCell
        let cellData = currentInfo.selectedMention["replies"] as! Array<Array<String>>
        cell.nameLabel.text = currentInfo.uidNameDict[cellData[indexPath.row][0]]
        cell.commentField.text = cellData[indexPath.row][2]
        setProfilePictures(pictureUrl: currentInfo.uidPictureDict[cellData[indexPath.row][0]]!, pictureHolder: cell.profilePictureHolder, userid: (cellData[indexPath.row][0]))
        return cell
    }
}
