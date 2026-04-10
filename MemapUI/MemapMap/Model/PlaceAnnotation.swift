//
//  PlaceAnnotation.swift
//  MemapUI
//
//  Created by Vu Dinh Phong on 23/03/2026.
//

import MapKit

public final class PlaceAnnotation: NSObject, MKAnnotation {
    public let id: UUID
    public let title: String?
    public let coordinate: CLLocationCoordinate2D
    
    public init(
        id: UUID,
        title: String?,
        latitude: Double,
        longitude: Double
    ) {
        self.id = id
        self.title = title
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
