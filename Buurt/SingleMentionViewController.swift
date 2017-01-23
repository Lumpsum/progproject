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
        
        let commentRef = ref.child(currentInfo.postcode).child((currentInfo.selectedMention["key"] as! String))
        
        var tempComments = currentInfo.selectedMention["replies"] as! Array<Array<String>>
        
        if tempComments[0] == ["test", "test", "test"] {
            tempComments.remove(at: 0)
        }
        
        tempComments.append([currentInfo.user["uid"]!, "\(NSDate())", commentField.text!])
        commentRef.updateChildValues(["replies": tempComments])
        
        updateMentions(selectedKey: currentInfo.selectedMention["key"] as? String)
        self.tableView.reloadData()
    }
    
    @IBAction func followAction(_ sender: Any) {
        if currentInfo.followlist.contains(currentInfo.selectedMention["key"] as! String) == false {
            let userRef = FIRDatabase.database().reference(withPath: "users").child(currentInfo.user["uid"]!)
            currentInfo.followlist.append(currentInfo.selectedMention["key"] as! String)
            userRef.updateChildValues(["followlist": currentInfo.followlist])
            //viewDidLoad()
        }
        else if currentInfo.followlist.contains(currentInfo.selectedMention["key"] as! String) {
            print("Have to delete this item")
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // SHOW INFORMATION
        self.title = currentInfo.selectedMention["titel"] as! String?
        nameLabel.text = currentInfo.uidNameDict[(currentInfo.selectedMention["addedByUser"] as! String?)!]
        timeLabel.text = getTimeDifference(inputDate: (currentInfo.selectedMention["timeStamp"] as! String?)!)
        messageField.text = currentInfo.selectedMention["message"] as! String?
        
        // SHOW MAP
        
        let dbLocation = currentInfo.selectedMention["location"] as! Dictionary<String, String>
        let initialLocation = CLLocation(latitude: Double(dbLocation["latitude"]!)!, longitude: Double(dbLocation["longitude"]!)!)
        centerMapOnLocation(location: initialLocation)
        let mapPointer = MapPointer(title: (currentInfo.selectedMention["titel"] as! String?)!, locationName: getLocation(longitude: Double(dbLocation["longitude"]!)!, latitude: Double(dbLocation["latitude"]!)!), coordinate: CLLocationCoordinate2D(latitude: Double(dbLocation["latitude"]!)!, longitude: Double(dbLocation["longitude"]!)!))
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
    
    
    
    
    
    let regionRadius: CLLocationDistance = 100
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (currentInfo.selectedMention["replies"] as! Array<Array<String>>).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentCell
        let cellData = currentInfo.selectedMention["replies"] as! Array<Array<String>>
        print("DICT", currentInfo.uidNameDict)
        print(cellData[indexPath.row][0])
        cell.nameLabel.text = currentInfo.uidNameDict[cellData[indexPath.row][0]]
        cell.commentField.text = cellData[indexPath.row][2]
        
        return cell
    }

}
