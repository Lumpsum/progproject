//
//  SingleMentionViewController.swift
//  Buurt
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
    
    @IBAction func saveComment(_ sender: Any) {
        updateMentions(selectedKey: currentInfo.selectedMention["key"] as? String)
        let commentRef = ref.child(currentInfo.user["postcode"]!).child((currentInfo.selectedMention["key"] as! String))
        var tempComments = currentInfo.selectedMention["replies"] as! Array<Array<String>>
        if tempComments[0].count == 0 {
            tempComments = Array<Array<String>>()
        }
        tempComments.append([currentInfo.user["uid"]!, "\(NSDate())", commentField.text!])
        commentRef.updateChildValues(["replies": tempComments])
        currentInfo.selectedMention["replies"] = tempComments
        updateMentions(selectedKey: currentInfo.selectedMention["key"] as? String)
        self.tableView.reloadData()
    }
    
    @IBAction func followAction(_ sender: Any) {
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
        
        // KEYBOARD NOTIFICATIONS
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // SHOW INFORMATION
        self.title = currentInfo.selectedMention["titel"] as! String?
        nameLabel.text = currentInfo.uidNameDict[(currentInfo.selectedMention["addedByUser"] as! String?)!]
        timeLabel.text = getTimeDifference(inputDate: (currentInfo.selectedMention["timeStamp"] as! String?)!)
        messageField.text = currentInfo.selectedMention["message"] as! String?
        
        // SET PICTURE OF WRITER
        let pictureUrl = currentInfo.uidPictureDict[(currentInfo.selectedMention["addedByUser"] as! String?)!]
        if pictureUrl != nil && pictureUrl != "" {
            self.profilePictureHolder.loadImagesWithCache(urlstring: pictureUrl!, uid: ((currentInfo.selectedMention["addedByUser"] as! String?)!))
            self.profilePictureHolder.layer.cornerRadius = self.profilePictureHolder.frame.size.width / 2
            self.profilePictureHolder.clipsToBounds = true
        }
        
        // SHOW MAP
        let dbLocation = currentInfo.selectedMention["location"] as! Dictionary<String, String>
        let initialLocation = CLLocation(latitude: Double(dbLocation["latitude"]!)!, longitude: Double(dbLocation["longitude"]!)!)
        centerMapOnLocation(location: initialLocation)
        
        var locationNameLocal = String()
        getLocation(longitude: Double(dbLocation["longitude"]!)!, latitude: Double(dbLocation["latitude"]!)!, completion: {(locationName: String) -> Void in
            locationNameLocal = locationName
            
        })
        
        let mapPointer = MapPointer(title: (currentInfo.selectedMention["titel"] as! String?)!, locationName: locationNameLocal, coordinate: CLLocationCoordinate2D(latitude: Double(dbLocation["latitude"]!)!, longitude: Double(dbLocation["longitude"]!)!))
        //mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(mapPointer)
        
        // SET FOLLOW ICON
        if currentInfo.followlist.contains(currentInfo.selectedMention["key"] as! String) {
            followIcon.tintColor = UIColor.green
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // KEYBOARD FUNCTIONS
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
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

    // CENTERING MAP
    let regionRadius: CLLocationDistance = 100
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    // TABLE FUNCTIONS
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
        
        let pictureUrl = currentInfo.uidPictureDict[cellData[indexPath.row][0]]
        if pictureUrl != nil && pictureUrl != "" {
            cell.profilePictureHolder.loadImagesWithCache(urlstring: pictureUrl!, uid: (cellData[indexPath.row][0]))
            cell.profilePictureHolder.layer.cornerRadius = cell.profilePictureHolder.frame.size.width / 2
            cell.profilePictureHolder.clipsToBounds = true
        }
        
        return cell
    }

}
