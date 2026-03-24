//
//  PlaceInfoItem.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 26/02/2026.
//

import Foundation

/// A model that represents data for MapView
public struct PlaceInfoViewModel {
    public let id: UUID
    public var name: String?
    public let latitude: Double
    public let longitude: Double
    public let createdTimestamp: Date?
    public let imagePath: String?
    public var isAdded: Bool
    
    public init(
        id: UUID,
        name: String? = nil,
        latitude: Double,
        longitude: Double,
        createdTimestamp: Date?,
        imagePath: String?,
        isAdded: Bool
    ) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.createdTimestamp = createdTimestamp
        self.imagePath = imagePath
        self.isAdded = isAdded
    }
}
