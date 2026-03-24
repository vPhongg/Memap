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
    public let latitude: Double?
    public let longitude: Double?
    public let createdTimestamp: Date
    public let imagePath: String?
    
    public init(
        id: UUID,
        name: String?,
        latitude: Double?,
        longitude: Double?,
        createdTimestamp: Date,
        imagePath: String?
    ) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.createdTimestamp = createdTimestamp
        self.imagePath = imagePath
    }
}

public extension LocalPlaceInfo {
    func toModel() -> PlaceInfo {
        return PlaceInfo(
            id: id,
            name: name,
            latitude: latitude,
            longitude: longitude,
            createdTimestamp: createdTimestamp,
            imagePath: imagePath,
            isAdded: true // Fix true because `LocalPlaceInfo` represent items from `Persistence Storage`, which means it surely saved to `Persistence Storage` previously.
        )
    }
}

extension Array where Element == LocalPlaceInfo {
    func toModels() -> [PlaceInfo] {
        return map { $0.toModel() }
    }
}
