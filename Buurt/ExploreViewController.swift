//
//  ExploreViewController.swift
//  Buurt
//
//  Created by Martijn de Jong on 17-01-17.
//  Copyright © 2017 Martijn de Jong. All rights reserved.
//

import UIKit
import MapKit

class ExploreViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var coordinates = Dictionary<String, String>()
    
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestLocation()
        
        // SIDEBARMENU ENABLED
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        placePinPoints()
    }
    
    /// Places a pinpoint for each mentions on the map.
    private func placePinPoints() {
        for item in currentInfo.mentions {
            let dbLocation = item.location as Dictionary<String, String>
            
            var locationNameLocal = String()
            getLocation(longitude: Double(dbLocation["longitude"]!)!, latitude: Double(dbLocation["latitude"]!)!, completion: {(locationName: String) -> Void in
                locationNameLocal = locationName
                
            })
            
            let mapPointer = MapPointer(title: item.titel, locationName: locationNameLocal, coordinate: CLLocationCoordinate2D(latitude: Double(dbLocation["latitude"]!)!, longitude: Double(dbLocation["longitude"]!)!))
            mapView.addAnnotation(mapPointer)
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
            coordinates["longitude"] = String(locations[0].coordinate.longitude)
            coordinates["latitude"] = String(locations[0].coordinate.latitude)
            let initialLocation = CLLocation(latitude: Double(coordinates["latitude"]!)!, longitude: Double(coordinates["longitude"]!)!)
            centerMapOnLocation(location: initialLocation, regionRadius: 1000, map: mapView)
        }
    }    
}
    


