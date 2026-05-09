//
//  LocalPlaceManager.swift
//  LocalMemapLoader
//
//  Created by Vu Dinh Phong on 25/02/2026.
//


import Foundation

public final class LocalPlaceManager {
    private let store: PlaceStore
    
    public init(store: PlaceStore) {
        self.store = store
    }
}

extension LocalPlaceManager: PlaceLoadable {
    public func load() async throws -> [Place] {
        return try await store.retrieve().toModels()
    }
}

extension LocalPlaceManager: PlaceSavable {
    public func save(_ place: Place) async throws {
        try await store.insert(place.toLocal())
    }
}

extension LocalPlaceManager: PlaceDeletable {
    public func delete(_ place: Place) async throws {
        try await store.delete(place.toLocal())
    }
}
