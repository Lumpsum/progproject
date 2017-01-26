//
//  PickLocationViewController.swift
//  Buurt
//
//  Created by Martijn de Jong on 26-01-17.
//  Copyright © 2017 Martijn de Jong. All rights reserved.
//

import UIKit
import MapKit

class PickLocationViewController: UIViewController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {

    var coordinatesDict = Dictionary<String, String>()
    var coordinates = CLLocationCoordinate2D()
    
    @IBOutlet var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
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
        
        coordinatesDict["longitude"] = String(coordinates.longitude)
        coordinatesDict["latitude"] = String(coordinates.latitude)
        print("PICKLOCATIONVC", coordinatesDict)
        
        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? NewMentionViewController {
            controller.coordinatesDict = coordinatesDict
            controller.coordinates = coordinates
            controller.viewDidLoad()
        }
    }
    

}
