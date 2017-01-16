//
//  SingleMentionViewController.swift
//  Buurt
//
//  Created by Martijn de Jong on 13-01-17.
//  Copyright © 2017 Martijn de Jong. All rights reserved.
//

import UIKit
import Firebase

class SingleMentionViewController: UIViewController {
    
    let ref = FIRDatabase.database().reference(withPath: "mentions")
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var profilePictureHolder: UIImageView!
    @IBOutlet var messageField: UITextView!
    
    @IBOutlet var commentField: UITextField!
    @IBAction func saveComment(_ sender: Any) {
        let commentRef = ref.child(currentInfo.postcode).child((currentInfo.selectedMention["key"] as! String))
        print((currentInfo.selectedMention["replies"]! as! Array<Array<String>>).count)
        var currentComments = currentInfo.selectedMention["replies"] as! Array<Array<String>>
        commentRef.updateChildValues(["replies": currentComments.append(["test3"])])
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = currentInfo.selectedMention["titel"] as! String?
        nameLabel.text = currentInfo.uidNameDict[(currentInfo.selectedMention["addedByUser"] as! String?)!]
        timeLabel.text = getTimeDifference(inputDate: (currentInfo.selectedMention["timeStamp"] as! String?)!)
        messageField.text = currentInfo.selectedMention["message"] as! String?
        print("SELECTED", currentInfo.selectedMention)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
