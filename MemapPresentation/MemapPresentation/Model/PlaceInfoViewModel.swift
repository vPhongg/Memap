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
    public let savedTimestamp: Date?
    public let imagesPath: String?
    public let videosPath: String?
    public let note: String?
    public var isSaved: Bool
    
    public init(
        id: UUID,
        name: String? = nil,
        latitude: Double,
        longitude: Double,
        savedTimestamp: Date?,
        imagesPath: String?,
        videosPath: String?,
        note: String?,
        isSaved: Bool
    ) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.savedTimestamp = savedTimestamp
        self.imagesPath = imagesPath
        self.videosPath = videosPath
        self.note = note
        self.isSaved = isSaved
    }
}
