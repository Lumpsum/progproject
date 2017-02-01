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
    
    var viewFunction = String()
    var loadDispatchGroup = DispatchGroup()
    var presentData = Array<MentionItem>()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var composeButton: UIBarButtonItem!
    @IBAction func unwindToFeed(segue: UIStoryboardSegue) {}

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData(_:)), name: .reload, object: nil)
        
        setPropertiesViewFunction()
        loadAllData()
        
        // SIDEBARMENU ENABLED
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Sets NavigationBar title and navigation item for the current view function.
    private func setPropertiesViewFunction() {
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
    }
    
    /// Get current user information from Firebase and store in currentInfo.user.
    private func setCurrentUserInfo(beginHandler: @escaping () -> (), completionHandler: @escaping () -> ()) {
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
    
    /// Performs updateUserDict() and updateMentions() after userinformation is retrieved in setCurrentUserInfo.
    private func loadAllData() {
        setCurrentUserInfo(beginHandler: {
            self.loadDispatchGroup.enter()
            self.loadDispatchGroup.notify(queue: DispatchQueue.main, execute: {
                updateUserDict()
                updateMentions(selectedKey: nil)
            })
        }, completionHandler: { self.loadDispatchGroup.leave() })
    }
    
    /// Used to reload data in tableView within observer.
    func reloadTableData(_ notification: Notification) {
        tableView.reloadData()
    }
    
    
    ///
    private func filterDataForFunction() {
        presentData = []
        if viewFunction == "follow" {
            for item in currentInfo.mentions {
                if currentInfo.followlist.contains(item.key){
                    presentData.append(item)
                }
            }
        }
        else if viewFunction == "mymentions" {
            for item in currentInfo.mentions {
                
                if item.addedByUser == currentInfo.user["uid"]!{
                    presentData.append(item)
                }
            }
        }
        else {
            presentData = currentInfo.mentions
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterDataForFunction()
        return presentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mentionCell", for: indexPath) as! MentionCell
        let cellData = presentData[indexPath.row].toAnyObject()
        cell.iconHolder.image = UIImage(named: (cellData["category"] as! String?)!)
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
            FIRDatabase.database().reference(withPath: "mentions").child(currentInfo.user["postcode"]!).child(self.presentData[indexPath.row].key).removeValue { (error, ref) in
                if error != nil {
                    print("error \(error)")
                }
            }
        }
    }
}
