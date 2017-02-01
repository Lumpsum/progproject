//
//  PickLocationViewController.swift
//  Buurt
//
//  Created by Martijn de Jong on 26-01-17.
//  Copyright © 2017 Martijn de Jong. All rights reserved.
//

import UIKit
import MapKit

class PickLocationViewController: UIViewController, UIGestureRecognizerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

    var coordinates = CLLocationCoordinate2D()
    var locationManager = CLLocationManager()
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestLocation()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: mapView)
        coordinates = mapView.convert(location,toCoordinateFrom: mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? NewMentionViewController {
            controller.coordinates = coordinates
            controller.viewDidLoad()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let initialLocation:CLLocation = manager.location!
        centerMapOnLocation(location: initialLocation, regionRadius: 1000, map: mapView)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
}
