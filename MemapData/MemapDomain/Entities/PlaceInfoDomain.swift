//
//  PlaceInfoDomain.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 11/03/2026.
//

import Foundation

/// This class is equivalent to `PlaceInfo`, but since `PlaceInfo` reside in `MemapData` so we can not use.
/// Following Clean Architectture, `PlaceInfo` should reside in `Domain` module
/// Thus creating `PlaceInfoDomain` just to an alternative to `PLaceInfo` to use, so we don't import `MemapData` in the `Domain` module.
/// The `Domain` module must not depend on `Data` module, but vice versa.
public struct PlaceInfoDomain: Equatable {
    public let id: UUID
    public let name: String?
    public let latitude: Double?
    public let longitude: Double?
    public let savedTimestamp: Date
    public let imagesPath: String?
    public let videosPath: String?
    public let note: String?
    public let isSaved: Bool
    
    public init(
        id: UUID,
        name: String?,
        latitude: Double?,
        longitude: Double?,
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
