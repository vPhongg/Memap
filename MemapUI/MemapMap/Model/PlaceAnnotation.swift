//
//  PlaceAnnotation.swift
//  MemapUI
//
//  Created by Vu Dinh Phong on 23/03/2026.
//

import MapKit

/// A model that represents item data on map.
public final class PlaceAnnotation: NSObject, MKAnnotation {
    public let id: String
    public let title: String?
    public let coordinate: CLLocationCoordinate2D
    public let createdTimestamp: Date?
    public let imagesPath: String?
    public let videosPath: String?
    public let note: String?
    public let isSaved: Bool
    public let backgroundColor: UIColor?
    public let type: MapItemType
    
    public init(
        id: String,
        title: String?,
        latitude: Double,
        longitude: Double,
        createdTimestamp: Date?,
        imagesPath: String?,
        videosPath: String?,
        note: String?,
        isSaved: Bool,
        backgroundColor: UIColor?,
        type: MapItemType
    ) {
        self.id = id
        self.title = title
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.createdTimestamp = createdTimestamp
        self.imagesPath = imagesPath
        self.videosPath = videosPath
        self.note = note
        self.isSaved = isSaved
        self.backgroundColor = backgroundColor
        self.type = type
    }
}
