//
//  NewMentionViewController.swift
//  Buurt
//
//  Created by Martijn de Jong on 10-01-17.
//  Copyright © 2017 Martijn de Jong. All rights reserved.
//

import UIKit
import Firebase

class NewMentionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let ref = FIRDatabase.database().reference(withPath: "mentions")
    
    var categoriesListDutch = ["Verdachte situatie", "Klacht", "Aandachtspunt", "Evenement", "Bericht"]
    
    
    @IBOutlet var titleField: UITextField!
    
    @IBOutlet var categoryField: UITextField!
    
    @IBOutlet var locationField: UITextField!
    
    @IBOutlet var messageField: UITextView!
    
    @IBAction func postMention(_ sender: Any) {
        if checkInput() == true {
            let mentionItem = MentionItem(titel: titleField.text!,
                                      addedByUser: "testuser",
                                      category: categoryField.text!,
                                      location: locationField.text!,
                                      message: messageField.text,
                                      timeStamp: String(describing: NSDate()),
                                      replies: ["test"])
            let mentionItemRef = ref.child(currentInfo.postcode).childByAutoId()
        
            mentionItemRef.setValue(mentionItem.toAnyObject())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var pickerView = UIPickerView()
        pickerView.delegate = self
        categoryField.inputView = pickerView

        // Do any additional setup after loading the view.
    }
    
    func checkInput() -> Bool {
        if titleField.text != "" && categoryField.text != "" && locationField.text != "" && messageField.text != "" {
            return true
        }
        else {
            let alert = UIAlertController(title: "Oeps!", message: "U heeft niet alle velden ingevuld.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoriesListDutch.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoriesListDutch[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryField.text = categoriesListDutch[row]
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
