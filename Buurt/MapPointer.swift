//
//  MapPointer.swift
//  Buurt
//
//  Created by Martijn de Jong on 17-01-17.
//  Copyright © 2017 Martijn de Jong. All rights reserved.
//

import Foundation
import MapKit

class MapPointer: NSObject, MKAnnotation {
    let title: String?
    //let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        //self.locationName = locationName
        self.coordinate = coordinate
        super.init()
    }
}
