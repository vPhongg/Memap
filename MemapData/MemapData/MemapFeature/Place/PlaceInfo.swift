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
    public let latitude: Double
    public let longitude: Double
    public let savedTimestamp: Date
    public let imagesPath: String?
    public let videosPath: String?
    public let note: String?
    public let isSaved: Bool
    
    public init(
        id: UUID,
        name: String?,
        latitude: Double,
        longitude: Double,
        savedTimestamp: Date,
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

public extension PlaceInfo {
    func toLocal() -> LocalPlaceInfo {
        return LocalPlaceInfo(
            id: id,
            name: name,
            latitude: latitude,
            longitude: longitude,
            savedTimestamp: savedTimestamp,
            imagesPath: imagesPath,
            videosPath: videosPath,
            note: note
        )
    }
}

extension Array where Element == PlaceInfo {
    func toLocals() -> [LocalPlaceInfo] {
        return map { $0.toLocal() }
    }
}
