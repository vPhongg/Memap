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
    
    public var isLoading: Bool = false
    public var places: [PlaceInfo] = []
        
    private let memapLoader: MemapLoader
    
    public init (
        memapLoader: MemapLoader,
    ) {
        self.memapLoader = memapLoader
    }
    
    public func load() async throws -> Void {
        defer { isLoading = false }
        
        isLoading = true
        
        places = try await self.memapLoader.load()
    }
    
}

extension Array where Element == PlaceInfo {
    public func toModels() -> [PlaceInfoViewModel] {
        return compactMap { item in
            if let lat = item.latitude, let long = item.longitude {
                return PlaceInfoViewModel(
                    id: item.id,
                    name: item.name,
                    latitude: lat,
                    longitude: long,
                    createdTimestamp: item.createdTimestamp,
                    imagePath: item.imagePath,
                    isAdded: item.isAdded
                )
            } else {
                return nil
            }
        }
    }
}

extension PlaceInfoViewModel {
    func toModel() -> PlaceInfo {
        PlaceInfo(
            id: id,
            name: name,
            latitude: latitude,
            longitude: longitude,
            createdTimestamp: createdTimestamp ?? Date(),
            imagePath: imagePath,
            isAdded: isAdded
        )
    }
}
