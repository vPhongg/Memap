//
//  PlaceInfoItem.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 26/02/2026.
//

import Foundation

/// A model that represents data for MapView
public struct PlaceInfoViewModel: Equatable {
    public let id: String
    public var name: String?
    public let latitude: Double
    public let longitude: Double
    public let savedTimestamp: Date?
    public let imagesPath: String?
    public let videosPath: String?
    public let note: String?
    public var isSaved: Bool
    public var backgroundColor: String?
    
    public init(
        id: String,
        name: String? = nil,
        latitude: Double,
        longitude: Double,
        savedTimestamp: Date?,
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
    
    public static func defaultObject() -> PlaceInfoViewModel {
        PlaceInfoViewModel(id: "anyID", name: .empty, latitude: 0, longitude: 0, savedTimestamp: Date(), imagesPath: nil, videosPath: nil, note: nil, isSaved: false, backgroundColor: "")
    }
}
