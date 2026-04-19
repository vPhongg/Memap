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
    public var places: [Place] = [] {
        didSet {
            placeGroups = [
                PlaceGroup(name: "Unknown", places: places.toPresentationModels() )
            ]
        }
    }
        
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
                backgroundColor: item.backgroundColor
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
            backgroundColor: backgroundColor
        )
    }
}
