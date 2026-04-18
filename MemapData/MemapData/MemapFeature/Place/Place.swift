//
//  Place.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 26/02/2026.
//


import Foundation

public struct Place: Equatable {
    public let id: String
    public let name: String?
    public let latitude: Double
    public let longitude: Double
    public let savedTimestamp: Date
    public let imagesPath: String?
    public let videosPath: String?
    public let note: String?
    public let isSaved: Bool
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
        isSaved: Bool,
        backgroundColor: String?
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
        self.backgroundColor = backgroundColor
    }
}

public extension Place {
    func toLocal() -> LocalPlace {
        return LocalPlace(
            id: id,
            name: name,
            latitude: latitude,
            longitude: longitude,
            savedTimestamp: savedTimestamp,
            imagesPath: imagesPath,
            videosPath: videosPath,
            note: note,
            backgroundColor: backgroundColor
        )
    }
}

extension Array where Element == Place {
    func toLocals() -> [LocalPlace] {
        return map { $0.toLocal() }
    }
}
