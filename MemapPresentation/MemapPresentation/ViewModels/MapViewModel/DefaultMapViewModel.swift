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

extension Array where Element == PlaceInfo {
    public func toModels() -> [PlaceInfoViewModel] {
        return compactMap { item in
            return PlaceInfoViewModel(
                id: item.id,
                name: item.name,
                latitude: item.latitude,
                longitude: item.longitude,
                savedTimestamp: item.savedTimestamp,
                imagesPath: item.imagesPath,
                videosPath: item.videosPath,
                note: item.note,
                isAdded: item.isAdded
            )
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
            savedTimestamp: savedTimestamp ?? Date(),
            imagesPath: imagesPath,
            videosPath: videosPath,
            note: note,
            isAdded: isAdded
        )
    }
}
