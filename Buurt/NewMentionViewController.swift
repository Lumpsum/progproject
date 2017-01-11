//
//  NewMentionViewController.swift
//  Buurt
//
//  Created by Martijn de Jong on 10-01-17.
//  Copyright © 2017 Martijn de Jong. All rights reserved.
//

import UIKit
import Firebase

class NewMentionViewController: UIViewController {
    
    let ref = FIRDatabase.database().reference(withPath: "mentions")
    
    @IBOutlet var titleField: UITextField!
    
    @IBOutlet var categoryField: UITextField!
    
    @IBOutlet var locationField: UITextField!
    
    @IBOutlet var messageField: UITextView!
    
    @IBAction func postMention(_ sender: Any) {
    
        let mentionItem = MentionItem(titel: titleField.text!,
                                      addedByUser: "testuser",
                                      location: locationField.text!,
                                      message: messageField.text,
                                      timeStamp: String(describing: NSDate()),
                                      replies: ["test"])
        // 3
        let mentionItemRef = ref.child(currentInfo.postcode).child((categoryField.text?.lowercased())!).childByAutoId()
        //let mentionItemRef = ref.child(currentInfo.postcode).childByAutoId()
        
        // 4
        mentionItemRef.setValue(mentionItem.toAnyObject())
    
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
