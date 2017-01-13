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
    
    @IBAction func LogOut(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
    }
    
    let ref = FIRDatabase.database().reference(withPath: "mentions")
    let categoriesDictDutch = ["Verdachte situatie":"warning", "Klacht":"complaint", "Aandachtspunt":"focus", "Evenement":"event", "Bericht":"message"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.child(currentInfo.postcode).observe(.value, with: { snapshot in
            let rawData = snapshot.value as? NSDictionary
            currentInfo.mentions = []
            if rawData != nil {
                for item in rawData! {
                    let mentionData = item.value as? NSDictionary
                    let mentionItem = MentionItem(titel: mentionData!["titel"] as! String, addedByUser: mentionData!["addedByUser"] as! String, category: mentionData!["category"] as! String, location: mentionData!["location"] as! String, message: mentionData!["message"] as! String, timeStamp: mentionData!["timeStamp"] as! String, replies: mentionData!["replies"] as! Array<Any>, key: item.key as! String)
                    currentInfo.mentions.append(mentionItem)
                }
            }
            //print("TEST", currentInfo.mentions[0].toAnyObject())
            self.tableView.reloadData()
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentInfo.mentions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mentionCell", for: indexPath) as! MentionCell
        let cellData = currentInfo.mentions[indexPath.row].toAnyObject()
        
        print(currentInfo.mentions.count)
        
        cell.iconHolder.image = UIImage(named:  categoriesDictDutch[(cellData["category"] as! String?)!]!)
        cell.titleLabel.text = cellData["titel"] as! String?
        print("ADDEDBYUSER", cellData["addedByUser"]!)
        cell.nameLabel.text = cellData["addedByUser"] as! String?
        cell.messageField.text = cellData["message"] as! String?
        cell.timeLabel.text = cellData["timeStamp"] as! String?
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentInfo.selectedMention = currentInfo.mentions[indexPath.row].toAnyObject()
    }
    
}
