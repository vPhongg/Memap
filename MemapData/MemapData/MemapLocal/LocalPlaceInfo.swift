//
//  PlaceInfo.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 26/02/2026.
//

import Foundation

public struct LocalPlaceInfo: Equatable {
    public let id: UUID
    public let name: String?
    public let latitude: Double
    public let longitude: Double
    public let savedTimestamp: Date
    public let imagesPath: String?
    public let videosPath: String?
    public let note: String?
    
    public init(
        id: UUID,
        name: String?,
        latitude: Double,
        longitude: Double,
        savedTimestamp: Date,
        imagesPath: String?,
        videosPath: String?,
        note: String?,
    ) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.imagesPath = imagesPath
        self.videosPath = videosPath
        self.savedTimestamp = savedTimestamp
        self.note = note
    }
}

public extension LocalPlaceInfo {
    func toModel() -> PlaceInfo {
        return PlaceInfo(
            id: id,
            name: name,
            latitude: latitude,
            longitude: longitude,
            savedTimestamp: savedTimestamp,
            imagesPath: imagesPath,
            videosPath: videosPath,
            note: note,
            isAdded: true // Fix true because `LocalPlaceInfo` represent items from `Persistence Storage`, which means it surely saved to `Persistence Storage` previously.
        )
    }
}

extension Array where Element == LocalPlaceInfo {
    func toModels() -> [PlaceInfo] {
        return map { $0.toModel() }
    }
}
