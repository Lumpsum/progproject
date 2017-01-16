//
//  SingleMentionViewController.swift
//  Buurt
//
//  Created by Martijn de Jong on 13-01-17.
//  Copyright © 2017 Martijn de Jong. All rights reserved.
//

import UIKit

class SingleMentionViewController: UIViewController {

    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var profilePictureHolder: UIImageView!
    @IBOutlet var messageField: UITextView!
    
    @IBOutlet var commentField: UITextField!
    @IBAction func saveComment(_ sender: Any) {
        //let commentRef = ref.child("mentions").child(currentInfo.postcode).child(currentInfo.selectedMention["added"])
        //mentionItemRef.setValue(mentionItem.toAnyObject())
        print(currentInfo.selectedMention)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = currentInfo.selectedMention["titel"] as! String?
        nameLabel.text = currentInfo.uidNameDict[(currentInfo.selectedMention["addedByUser"] as! String?)!]
        timeLabel.text = getTimeDifference(inputDate: (currentInfo.selectedMention["timeStamp"] as! String?)!)
        messageField.text = currentInfo.selectedMention["message"] as! String?
        print(currentInfo.selectedMention)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
