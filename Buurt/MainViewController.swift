//
//  MainViewController.swift
//  Buurt
//
//  Created by Martijn de Jong on 10-01-17.
//  Copyright © 2017 Martijn de Jong. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var menuButton: UIBarButtonItem!
    
    
    var viewFunction = String()
    let ref = FIRDatabase.database().reference(withPath: "mentions")
    let categoriesDictDutch = ["Verdachte situatie":"warning", "Klacht":"complaint", "Aandachtspunt":"focus", "Evenement":"event", "Bericht":"message"]
    
    // ASYNC TEST VARIABEL
    var group1 = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData(_:)), name: .reload, object: nil)
        
        // SET TITLE BAR
        if viewFunction == "follow" {
            self.title = "Volgend"
        }
        else if viewFunction == "mymentions" {
            self.title = "Mijn meldingen"
        }
        else {
            self.title = "Feed"
        }
        
        // LOAD ALL DATA
        group1.enter()
        FIRDatabase.database().reference(withPath: "users").observe(.value, with: { snapshot in
            let userData = (snapshot.value as? NSDictionary)!
            for item in userData {
                let userDetails = item.value as? NSDictionary
                if item.key as! String == currentInfo.user["uid"]! {
                    currentInfo.user["firstname"] = userDetails!["firstname"] as? String
                    currentInfo.user["lastname"] = userDetails!["lastname"] as? String
                    currentInfo.user["email"] = userDetails!["email"] as? String
                    currentInfo.user["postcode"] = userDetails!["postcode"] as? String
                    currentInfo.followlist = (userDetails!["followlist"] as? Array<String>)!
                }
            }
            self.group1.leave()
        })
            
        group1.notify(queue: DispatchQueue.main, execute: {
            print("Finished all requests.")
            print("POSTCODE:", currentInfo.user["postcode"]!)
            updateUserDict()
            updateMentions(selectedKey: nil)
        })
        
        
        // GET MENTIONS FROM FIREBASE
        //updateMentions(selectedKey: nil)
        
        // GET ALL USER DATA
        //updateCurrentUserInfo()
        
        // GET USERID:USER DICTIONARY
        //updateUserDict()
        
        
        // SIDEBARMENU ENABLED
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
    }

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
                print("UID 1: \(item.addedByUser), UID 2: \(currentInfo.user["uid"]!)")
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
        print("presentData", presentData)
        let cellData = presentData[indexPath.row].toAnyObject()
        cell.iconHolder.image = UIImage(named:  categoriesDictDutch[(cellData["category"] as! String?)!]!)
        cell.titleLabel.text = cellData["titel"] as! String?
        cell.nameLabel.text = currentInfo.uidNameDict[(cellData["addedByUser"] as! String?)!]
        cell.messageField.text = cellData["message"] as! String?
        cell.timeLabel.text = getTimeDifference(inputDate: (cellData["timeStamp"] as! String?)!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentInfo.selectedMention = currentInfo.mentions[indexPath.row].toAnyObject()
    }
    
}
