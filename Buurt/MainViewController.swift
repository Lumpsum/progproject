//
//  MainViewController.swift
//  Buurt
//
//  Created by Martijn de Jong on 10-01-17.
//  Copyright © 2017 Martijn de Jong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var composeButton: UIBarButtonItem!
    
    @IBAction func unwindToFeed(segue: UIStoryboardSegue) {
        
    }
    
    var viewFunction = String()
    let ref = FIRDatabase.database().reference(withPath: "mentions")
    let categoriesDictDutch = ["Verdachte situatie":"warning", "Klacht":"complaint", "Aandachtspunt":"focus", "Evenement":"event", "Bericht":"message"]
    var group1 = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData(_:)), name: .reload, object: nil)
        
        // SET TITLE BAR
        if viewFunction == "follow" {
            self.title = "Volgend"
            self.navigationItem.rightBarButtonItem = nil
        }
        else if viewFunction == "mymentions" {
            self.title = "Mijn meldingen"
            self.navigationItem.rightBarButtonItem = nil
        }
        else {
            self.title = "Feed"
        }
        
        // LOAD ALL DATA
        loadAllData()
        
        // SIDEBARMENU ENABLED
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    
    // LOAD FIRST USER DATA, SECOND MENTIONS AND UID/NAME DICT
    func loadAllData() {
        observeDatabase(beginHandler: {
            self.group1.enter()
            self.group1.notify(queue: DispatchQueue.main, execute: {
                updateUserDict()
                updateMentions(selectedKey: nil)
            })
        }, completionHandler: { self.group1.leave() })
    }
    
    func observeDatabase(beginHandler: @escaping () -> (), completionHandler: @escaping () -> ()) {
        FIRDatabase.database().reference(withPath: "users").observe(.value, with: { snapshot in
            beginHandler()
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
            completionHandler()
        })
    }
    
    // HELP FUNCTIONS
    func reloadTableData(_ notification: Notification) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // TABELE METHODS
    var presentData = Array<MentionItem>()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presentData = []
        if viewFunction == "follow" {
            for item in currentInfo.mentions {
                if currentInfo.followlist.contains(item.key){
                    presentData.append(item)
                }
            }
            return presentData.count
        }
        else if viewFunction == "mymentions" {
            for item in currentInfo.mentions {

                if item.addedByUser == currentInfo.user["uid"]!{
                    presentData.append(item)
                }
            }
            return presentData.count
        }
        else {
            presentData = currentInfo.mentions
            return presentData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mentionCell", for: indexPath) as! MentionCell
        let cellData = presentData[indexPath.row].toAnyObject()
        cell.iconHolder.image = UIImage(named:  categoriesDictDutch[(cellData["category"] as! String?)!]!)
        cell.titleLabel.text = cellData["titel"] as! String?
        cell.nameLabel.text = currentInfo.uidNameDict[(cellData["addedByUser"] as! String?)!]
        cell.messageField.text = cellData["message"] as! String?
        cell.timeLabel.text = getTimeDifference(inputDate: (cellData["timeStamp"] as! String?)!)
        
        let pictureUrl = currentInfo.uidPictureDict[(cellData["addedByUser"] as! String?)!]
        if pictureUrl != nil && pictureUrl != "" {
            cell.profilePictureHolder.loadImagesWithCache(urlstring: pictureUrl!, uid: (cellData["addedByUser"] as! String?)!)
            cell.profilePictureHolder.layer.cornerRadius = cell.profilePictureHolder.frame.size.width / 2
            cell.profilePictureHolder.clipsToBounds = true
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentInfo.selectedMention = presentData[indexPath.row].toAnyObject()
        print("HIER", currentInfo.selectedMention)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if viewFunction == "mymentions" {
            return true
        }
        else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            ref.child(currentInfo.user["postcode"]!).child(self.presentData[indexPath.row].key).removeValue { (error, ref) in
                if error != nil {
                    print("error \(error)")
                }
            }
        }
    }
}
