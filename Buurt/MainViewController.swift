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
    
    let ref = FIRDatabase.database().reference(withPath: "mentions")
    let testArray = ["Testbericht1", "Testbericht2", "Testbericht3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.child(currentInfo.postcode).observe(.value, with: { snapshot in
            let rawData = snapshot.value as? NSDictionary
            currentInfo.mentions = []
            
            for category in rawData!{
                let categoryData = category.value as? NSDictionary
                for item in categoryData! {
                    let mentionData = item.value as? NSDictionary
                    let mentionItem = MentionItem(titel: mentionData!["titel"] as! String, addedByUser: mentionData!["addedByUser"] as! String, location: mentionData!["location"] as! String, message: mentionData!["message"] as! String, timeStamp: mentionData!["timeStamp"] as! String, replies: mentionData!["replies"] as! Array<Any>, key: item.key as! String)
                    currentInfo.mentions.append(mentionItem)
                }
            }
            print("TEST", currentInfo.mentions[0].toAnyObject())
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(currentInfo.mentions.count)
        return currentInfo.mentions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mentionCell", for: indexPath) as! MentionCell
        let cellData = currentInfo.mentions[indexPath.row].toAnyObject()
        
        cell.titleLabel.text = cellData["titel"] as! String?
        cell.iconHolder.image = UIImage(named: "warning")
        return cell
    }
    
}
