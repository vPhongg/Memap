//
//  MMapItem.swift
//  MemapMap
//
//  Created by Vu Dinh Phong on 28/02/2026.
//

import Foundation
import MapKit
import SwiftUI

public struct MMapItem: Hashable {
    public let id: String
    public let name: String?
    public let latitude: Double
    public let longitude: Double
    public let createdTimestamp: Date?
    public let imagesPath: String?
    public let videosPath: String?
    public let note: String?
    public let isSaved: Bool
    public let backgroundColor: UIColor?
    
    public init(
        id: String,
        name: String?,
        latitude: Double,
        longitude: Double,
        createdTimestamp: Date?,
        imagesPath: String?,
        videosPath: String?,
        note: String?,
        isSaved: Bool,
        backgroundColor: UIColor?,
    ) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.createdTimestamp = createdTimestamp
        self.imagesPath = imagesPath
        self.videosPath = videosPath
        self.note = note
        self.isSaved = isSaved
        self.backgroundColor = backgroundColor
    }
    
}

extension Optional where Wrapped == MMapItem {
    func toPlaceAnnotation() -> PlaceAnnotation? {
        guard let self else { return nil }
        return self.toPlaceAnnotation()
    }
}

extension MMapItem {
    
    func toPlaceAnnotation() -> PlaceAnnotation {
        PlaceAnnotation(
            id: self.id,
            title: self.name,
            latitude: self.latitude,
            longitude: self.longitude,
            createdTimestamp: self.createdTimestamp,
            imagesPath: self.imagesPath,
            videosPath: self.videosPath,
            note: self.note,
            isSaved: self.isSaved,
            backgroundColor: self.backgroundColor
        )
    }
}

extension Array where Element == MMapItem {
    func toPlaceAnnotations() -> [PlaceAnnotation] {
        return map { $0.toPlaceAnnotation() }
    }
}

extension MMapItem {
    
    static func from(_ annotation: MKMapFeatureAnnotation) -> Self {
        .init(
            id: generatePlaceID(lat: annotation.coordinate.latitude, long: annotation.coordinate.longitude),
            name: annotation.title,
            latitude: annotation.coordinate.latitude,
            longitude: annotation.coordinate.longitude,
            createdTimestamp: nil,
            imagesPath: nil,
            videosPath: nil,
            note: nil,
            isSaved: false,
            backgroundColor: annotation.iconStyle?.backgroundColor,
        )
    }
    
    static func from(_ annotation: PlaceAnnotation) -> Self {
        .init(
            id: annotation.id,
            name: annotation.title,
            latitude: annotation.coordinate.latitude,
            longitude: annotation.coordinate.longitude,
            createdTimestamp: annotation.createdTimestamp,
            imagesPath: annotation.imagesPath,
            videosPath: annotation.videosPath,
            note: annotation.note,
            isSaved: annotation.isSaved,
            backgroundColor: annotation.backgroundColor
        )
    }
    
    private static func generatePlaceID(lat: CLLocationDegrees, long: CLLocationDegrees) -> String {
        return "\(lat.toString)_\(long.toString)"
    }
    
}
