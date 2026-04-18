//
//  LocalPlaceInfo.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 26/02/2026.
//

import Foundation

public struct LocalPlaceInfo: Equatable {
    public let id: String
    public let name: String?
    public let latitude: Double
    public let longitude: Double
    public let savedTimestamp: Date
    public let imagesPath: String?
    public let videosPath: String?
    public let note: String?
    public let backgroundColor: String?
    
    public init(
        id: String,
        name: String?,
        latitude: Double,
        longitude: Double,
        savedTimestamp: Date,
        imagesPath: String?,
        videosPath: String?,
        note: String?,
        backgroundColor: String?
    ) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.imagesPath = imagesPath
        self.videosPath = videosPath
        self.savedTimestamp = savedTimestamp
        self.note = note
        self.backgroundColor = backgroundColor
    }
}

public extension LocalPlaceInfo {
    func toModel() -> Place {
        return Place(
            id: id,
            name: name,
            latitude: latitude,
            longitude: longitude,
            savedTimestamp: savedTimestamp,
            imagesPath: imagesPath,
            videosPath: videosPath,
            note: note,
            isSaved: true, // Fix true because `LocalPlaceInfo` represent items from `Persistence Storage`, which means it surely saved to `Persistence Storage` previously.
            backgroundColor: backgroundColor
        )
    }
}

extension Array where Element == LocalPlaceInfo {
    func toModels() -> [Place] {
        return map { $0.toModel() }
    }
}
