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
    let categoriesDictDutch = ["Verdachte situatie":"warning", "Klacht":"complaint", "Aandachtspunt":"focus", "Evenement":"event", "Bericht":"message"]
    
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
                                      category: categoriesDictDutch[categoryField.text!]!,
                                      location: ["latitude": String(coordinates.latitude), "longitude": String(coordinates.longitude)],
                                      message: messageField.text,
                                      timeStamp: String(describing: NSDate().timeIntervalSince1970))
        let mentionItemRef = FIRDatabase.database().reference(withPath: "mentions").child(currentInfo.user["postcode"]!).childByAutoId()
        mentionItemRef.setValue(mentionItem.toAnyObject())
    }
    
    private func setLocationField() {
        getLocationName(longitude: coordinates.longitude, latitude: coordinates.latitude, completion: {(locationName: String) -> Void in
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
    
    /// Takes coordinates and gives back the adress as String and checks if the given location is in the postalcode area of the current user. Gives back "invalid" if location is outside the postalcode area.
    private func getLocationName(longitude: CLLocationDegrees, latitude: CLLocationDegrees, completion: @escaping (_ locationName: String) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
            }
            
            if (placemarks?.count)! > 0 {
                let pm = (placemarks?[0])! as CLPlacemark
                
                if self.postalcodeCheck(fullPostalcode: pm.postalCode!) {
                    completion((pm.name! as String))
                }
                else {
                    completion("invalid")
                }
            }
                
            else {
                print("Couldn't find address")
            }
        })
    }
    
    /// Helpfunction of getLocation(). Checks if location is in postalcode area of the current user.
    private func postalcodeCheck(fullPostalcode: String) -> Bool {
        let index = fullPostalcode.index(fullPostalcode.startIndex, offsetBy: 4)
        let postalcode = fullPostalcode.substring(to: index)
        if postalcode == currentInfo.user["postcode"] {
            return true
        }
        else {
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
        if manager.location?.coordinate != nil {
            let locValue:CLLocationCoordinate2D = (manager.location?.coordinate)!
            coordinates = locValue
            setLocationField()
        }
    }
    
    // MARK: Pickerview functions.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return  Array(categoriesDictDutch.keys).count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(categoriesDictDutch.keys)[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryField.text = Array(categoriesDictDutch.keys)[row]
    }
}
