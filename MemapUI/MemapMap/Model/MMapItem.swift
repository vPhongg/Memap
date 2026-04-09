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
    public let id: UUID
    public let name: String?
    public let latitude: Double
    public let longitude: Double
    public let createdTimestamp: Date?
    public let imagesPath: String?
    public let videosPath: String?
    public let note: String?
    public var mapItem: MKMapItem?
    public let isAdded: Bool
    
    public init(
        id: UUID,
        name: String?,
        latitude: Double,
        longitude: Double,
        createdTimestamp: Date?,
        imagesPath: String?,
        videosPath: String?,
        note: String?,
        mapItem: MKMapItem? = nil,
        isAdded: Bool
    ) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.createdTimestamp = createdTimestamp
        self.imagesPath = imagesPath
        self.videosPath = videosPath
        self.note = note
        self.mapItem = mapItem
        self.isAdded = isAdded
    }
    
    func toMKMapItem() -> MKMapItem {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        var mapItem: MKMapItem
        
        if #available(iOS 26.0, *) {
            mapItem = MKMapItem(location: location, address: nil)
        } else {
            let placeMark = MKPlacemark(coordinate: location.coordinate)
            mapItem = MKMapItem(placemark: placeMark)
        }
        
        mapItem.name = name
        return mapItem
    }
}

extension Array where Element == MMapItem {
    func toMKMapItems() -> [MKMapItem] {
        return map { $0.toMKMapItem() }
    }
    
    func addMKMapItem() -> [MMapItem] {
        map { item in
            var copy = item
            copy.mapItem = item.toMKMapItem()
            return copy
        }
    }
}

extension MMapItem {
    static func from(_ feature: MapFeature) -> Self {
        .init(
            id: UUID(),
            name: feature.title,
            latitude: feature.coordinate.latitude,
            longitude: feature.coordinate.longitude,
            createdTimestamp: nil,
            imagesPath: nil,
            videosPath: nil,
            note: nil,
            isAdded: false
        )
    }
}


extension Array where Element == MMapItem {
    func toMapPlaces() -> [MapPlace] {
        return map {
            MapPlace(
                title: $0.name,
                latitude: $0.latitude,
                longitude: $0.longitude
            )
        }
    }
}
