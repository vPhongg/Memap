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
        
        setUponMKAnnotationView()
        setUponMKMarkerAnnotationView()
    }
    
    private func setUponMKAnnotationView() {
        displayPriority = .defaultHigh
    }
    
    private func setUponMKMarkerAnnotationView() {
        glyphImage = UIImage(systemName: "mappin.and.ellipse")
        markerTintColor = placeAnnotation?.backgroundColor
    }
    
}
