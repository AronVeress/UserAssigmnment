//
//  MapViewAnnotation.swift
//  UserJSON1
//
//  Created by Aron Veress on 06/12/2022.
//

import Foundation
import MapKit

class MyAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var picture: URL
    var id: String
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, picture: URL, id: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.picture = picture
        self.id = id
        
        super.init()
    }
}
