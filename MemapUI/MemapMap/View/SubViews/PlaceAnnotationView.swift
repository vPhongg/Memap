//
//  PlaceAnnotationView.swift
//  MemapUI
//
//  Created by Vu Dinh Phong on 23/03/2026.
//

import MapKit
import SwiftUI

class PlaceAnnotationView: MKMarkerAnnotationView {
    
    var placeAnnotation: PlaceAnnotation?
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "CustomPlaceAnnotation"
        self.placeAnnotation = annotation as? PlaceAnnotation
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// - Tag: DisplayConfiguration
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        markerTintColor = placeAnnotation?.backgroundColor
        glyphImage = UIImage(systemName: "person.crop.square.badge.camera.fill")
    }
    
}
