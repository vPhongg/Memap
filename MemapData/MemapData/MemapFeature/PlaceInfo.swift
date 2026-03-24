//
//  PlaceInfo.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 26/02/2026.
//


import Foundation

public struct PlaceInfo: Equatable {
    public let id: UUID
    public let name: String?
    public let latitude: Double?
    public let longitude: Double?
    public let createdTimestamp: Date
    public let imagePath: String?
    public let isAdded: Bool
    
    public init(
        id: UUID,
        name: String?,
        latitude: Double?,
        longitude: Double?,
        createdTimestamp: Date,
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

public extension PlaceInfo {
    func toLocal() -> LocalPlaceInfo {
        return LocalPlaceInfo(
            id: id,
            name: name,
            latitude: latitude,
            longitude: longitude,
            createdTimestamp: createdTimestamp,
            imagePath: imagePath
        )
    }
}

extension Array where Element == PlaceInfo {
    func toLocals() -> [LocalPlaceInfo] {
        return map { $0.toLocal() }
    }
}
