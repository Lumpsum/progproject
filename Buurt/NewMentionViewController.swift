//
//  NewMentionViewController.swift
//  Buurt
//
//  Created by Martijn de Jong on 10-01-17.
//  Copyright © 2017 Martijn de Jong. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class NewMentionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {
    
    let ref = FIRDatabase.database().reference(withPath: "mentions")
    let locationManager = CLLocationManager()
    var categoriesListDutch = ["Verdachte situatie", "Klacht", "Aandachtspunt", "Evenement", "Bericht"]
    var coordinates = Dictionary<String, String>()
    
    @IBOutlet var titleField: UITextField!
    
    @IBOutlet var categoryField: UITextField!
    
    @IBOutlet var locationField: UITextField!
    
    @IBOutlet var messageField: UITextView!
    
    @IBAction func postMention(_ sender: Any) {
        if checkInput() == true {
            let mentionItem = MentionItem(titel: titleField.text!,
                                      addedByUser: currentInfo.uid,
                                      category: categoryField.text!,
                                      location: coordinates,
                                      message: messageField.text,
                                      timeStamp: String(describing: NSDate()),
                                      replies: [["test", "test", "test"]])
            let mentionItemRef = ref.child(currentInfo.postcode).childByAutoId()
        
            mentionItemRef.setValue(mentionItem.toAnyObject())
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var pickerView = UIPickerView()
        pickerView.delegate = self
        categoryField.inputView = pickerView
        
        
        
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
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
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        coordinates["longitude"] = String(locValue.longitude)
        coordinates["latitude"] = String(locValue.latitude)
        self.locationField.text =  getLocation(longitude: locValue.longitude, latitude: locValue.latitude)
        if self.locationField.text != "" {
            locationManager.stopUpdatingLocation()
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

}
