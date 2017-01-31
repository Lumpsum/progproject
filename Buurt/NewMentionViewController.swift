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
    
    let locationManager = CLLocationManager()
    var coordinates = CLLocationCoordinate2D()
    
    @IBOutlet var titleField: UITextField!
    @IBOutlet var categoryField: UITextField!
    @IBOutlet var locationField: UITextField!
    @IBOutlet var messageField: UITextView!
    
    @IBAction func PostMentionButtonDidTouch(_ sender: Any) {
        if checkInput() == true {
            saveMention()
            self.performSegue(withIdentifier: "UnwindToFeedSegue", sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        messageField.layer.borderColor = UIColor(red:0.78, green:0.78, blue:0.80, alpha:1.0).cgColor
        messageField.layer.borderWidth = 0.5
        messageField.layer.cornerRadius = 5
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        categoryField.inputView = pickerView

        if coordinates.longitude == 0.0 {
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.requestLocation()
            }
        }
    
        if coordinates.latitude != 0.0 {
            setLocationField()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func saveMention() {
        let mentionItem = MentionItem(titel: titleField.text!,
                                      addedByUser: currentInfo.user["uid"]!,
                                      category: categoryField.text!,
                                      location: ["latitude": String(coordinates.latitude), "longitude": String(coordinates.longitude)],
                                      message: messageField.text,
                                      timeStamp: String(describing: NSDate()))
        let mentionItemRef = FIRDatabase.database().reference(withPath: "mentions").child(currentInfo.user["postcode"]!).childByAutoId()
        mentionItemRef.setValue(mentionItem.toAnyObject())
    }
    
    private func setLocationField() {
        getLocation(longitude: coordinates.longitude, latitude: coordinates.latitude, completion: {(locationName: String) -> Void in
            if locationName == "invalid" {
                let alert = UIAlertController(title: "Locatiefout", message: "De gekozen locatie bevindt zich niet in uw woonwijk.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                self.locationField.text = locationName
            }
        })
    }
    
    private func checkInput() -> Bool {
        if titleField.text != "" && categoryField.text != "" && locationField.text != "" && messageField.text != "" {
            return true
        }
        else {
            let alert = UIAlertController(title: "Melden mislukt", message: "U heeft niet alle velden ingevuld.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.first != nil {
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            coordinates = locValue
            setLocationField()
        }
    }
    
    // Pickerview functions
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return  Array(currentInfo.categoriesDictDutch.keys).count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(currentInfo.categoriesDictDutch.keys)[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryField.text = Array(currentInfo.categoriesDictDutch.keys)[row]
    }
}
