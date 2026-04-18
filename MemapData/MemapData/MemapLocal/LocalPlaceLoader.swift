//
//  LocalPlaceLoader.swift
//  LocalMemapLoader
//
//  Created by Vu Dinh Phong on 25/02/2026.
//


import Foundation

public final class LocalPlaceLoader {
    private let store: PlaceStore
    
    public init(store: PlaceStore) {
        self.store = store
    }
}

extension LocalPlaceLoader: PlaceLoader {
    public func load() async throws -> [Place] {
        return try await store.retrieve().toModels()
    }
}

extension LocalPlaceLoader: PlaceSaver {
    public func save(_ place: Place) async throws {
        try await store.insert(place.toLocal())
    }
}

extension LocalPlaceLoader: PlaceDeletor {
    public func delete(_ place: Place) async throws {
        try await store.delete(place.toLocal())
    }
}
