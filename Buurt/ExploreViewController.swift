//
//  ExploreViewController.swift
//  Buurt
//
//  Created by Martijn de Jong on 17-01-17.
//  Copyright © 2017 Martijn de Jong. All rights reserved.
//

import UIKit
import MapKit

class ExploreViewController: UIViewController {
    
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // SIDEBARMENU ENABLED
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        for item in currentInfo.mentions {
            let dbLocation = item.location as Dictionary<String, String>
            let mapPointer = MapPointer(title: item.titel, locationName: getLocation(longitude: Double(dbLocation["longitude"]!)!, latitude: Double(dbLocation["latitude"]!)!), coordinate: CLLocationCoordinate2D(latitude: Double(dbLocation["latitude"]!)!, longitude: Double(dbLocation["longitude"]!)!))
            
            mapView.addAnnotation(mapPointer)
        }
        
        
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
