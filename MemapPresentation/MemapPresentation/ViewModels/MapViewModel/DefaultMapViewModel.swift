//
//  MapViewModel.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 25/02/2026.
//

import Foundation
import MemapData

@Observable
final public class DefaultMapViewModel: MapViewModel {
    
    public var placeGroups: [PlaceGroup] = []
    public var isLoading: Bool = false
    public var places: [Place] = []
        
    private let memapLoader: PlaceLoader
    
    public init (
        memapLoader: PlaceLoader,
    ) {
        self.memapLoader = memapLoader
    }
    
    public func load() async throws -> Void {
        defer { isLoading = false }
        
        isLoading = true
        
        places = try await self.memapLoader.load()
    }
    
}

extension Array where Element == Place {
    public func toPresentationModels() -> [PlacePresentationModel] {
        return compactMap { item in
            return PlacePresentationModel(
                id: item.id,
                name: item.name ?? .empty,
                latitude: item.latitude,
                longitude: item.longitude,
                savedTimestamp: item.savedTimestamp,
                imagesPath: item.imagesPath,
                videosPath: item.videosPath,
                note: item.note,
                isSaved: item.isSaved,
                backgroundColor: item.backgroundColor,
                type: item.type.toPlaceTypePresentationModel(),
                address: item.address ?? .empty
            )
        }
    }
}

extension PlacePresentationModel {
    func toPresentationModel() -> Place {
        Place(
            id: id,
            name: name,
            latitude: latitude,
            longitude: longitude,
            savedTimestamp: savedTimestamp ?? Date(),
            imagesPath: imagesPath,
            videosPath: videosPath,
            note: note,
            isSaved: isSaved,
            backgroundColor: backgroundColor,
            type: type.toPlaceType(),
            address: address,
        )
    }
}

extension PlaceType {
    func toPlaceTypePresentationModel() -> PlaceTypePresentationModel {
        if let type = PlaceTypePresentationModel(rawValue: self.rawValue) {
            return type
        } else {
            return .unknown
        }
    }
}

extension PlaceTypePresentationModel {
    func toPlaceType() -> PlaceType {
        if let type = PlaceType(rawValue: self.rawValue) {
            return type
        } else {
            return .unknown
        }
    }
}
