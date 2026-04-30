//
//  PlacePresentationModel.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 26/02/2026.
//

import Foundation
import MemapData

/// A model that represents data for MapView
public struct PlacePresentationModel: Identifiable, Equatable {
    public let id: String
    public var name: String
    public let latitude: Double
    public let longitude: Double
    public let savedTimestamp: Date?
    public let imagesPath: String?
    public let videosPath: String?
    public let note: String?
    public var isSaved: Bool
    public var backgroundColor: String?
    public var type: PlaceTypePresentationModel
    public var address: String
    
    public init(
        id: String,
        name: String,
        latitude: Double,
        longitude: Double,
        savedTimestamp: Date?,
        imagesPath: String?,
        videosPath: String?,
        note: String?,
        isSaved: Bool,
        backgroundColor: String?,
        type: PlaceTypePresentationModel,
        address: String,
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
        self.type = type
        self.address = address
    }
    
    public static func defaultObject() -> PlacePresentationModel {
        PlacePresentationModel(id: UUID().uuidString, name: "This is any place name", latitude: 0, longitude: 0, savedTimestamp: Date(), imagesPath: nil, videosPath: nil, note: nil, isSaved: false, backgroundColor: nil, type: .unknown, address: Constant.unknownAddress.localized)
    }
}
