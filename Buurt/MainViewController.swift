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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("VIEWFUNCTION:", viewFunction)
        
        
        // GET MENTIONS FROM FIREBASE
        updateMentions(selectedKey: nil)
        self.tableView.reloadData()
        
        
        // GET ALL USER DATA
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
        })
        
        
        
        // SIDEBARMENU ENABLED
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
      
        FIRDatabase.database().reference(withPath: "users").observe(.value, with: { snapshot in
            let userData = (snapshot.value as? NSDictionary)!
            for item in userData {
                let userDetails = item.value as? NSDictionary
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
        //currentInfo.mentions = currentInfo.mentions.reversed() //To make sure that the new mentions are on top
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
