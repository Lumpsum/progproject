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
    
    let ref = FIRDatabase.database().reference(withPath: "mentions")
    let categoriesDictDutch = ["Verdachte situatie":"warning", "Klacht":"complaint", "Aandachtspunt":"focus", "Evenement":"event", "Bericht":"message"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // SIDEBARMENU ENABLED
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // GET MENTIONS FROM FIREBASE
        ref.child(currentInfo.postcode).observe(.value, with: { snapshot in
            let rawData = snapshot.value as? NSDictionary
            currentInfo.mentions = []
            if rawData != nil {
                for item in rawData! {
                    let mentionData = item.value as? NSDictionary
                    let mentionItem = MentionItem(titel: mentionData!["titel"] as! String, addedByUser: mentionData!["addedByUser"] as! String, category: mentionData!["category"] as! String, location: mentionData!["location"] as! String, message: mentionData!["message"] as! String, timeStamp: mentionData!["timeStamp"] as! String, replies: mentionData!["replies"] as! Array<Array<Any>>, key: item.key as! String)
                    currentInfo.mentions.append(mentionItem)
                }
            }
            
            self.tableView.reloadData()
        })
        
        // GET USER LIST (NOW ALL USERS, NEED TO EDDIT THIS)
        FIRDatabase.database().reference(withPath: "users").observe(.value, with: { snapshot in
            var userData = (snapshot.value as? NSDictionary)!
            for item in userData {
                var userDetails = item.value as? NSDictionary
                currentInfo.uidNameDict[item.key as! String] = "\(userDetails!["firstname"] as! String) \(userDetails!["lastname"] as! String)"
            }
            
            self.tableView.reloadData()
        })
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentInfo.mentions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mentionCell", for: indexPath) as! MentionCell
        let cellData = currentInfo.mentions[indexPath.row].toAnyObject()
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
