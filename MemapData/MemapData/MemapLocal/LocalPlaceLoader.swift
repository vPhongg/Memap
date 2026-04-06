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
    public func load() async throws -> [PlaceInfo] {
        return try await store.retrieve().toModels()
    }
}

extension LocalPlaceLoader: MemapPersistence {
    public func save(_ place: PlaceInfo) async throws {
        try await store.insert(place.toLocal())
    }
}

extension LocalPlaceLoader: MemapDelete {
    public func delete(_ place: PlaceInfo) async throws {
        try await store.delete(place.toLocal())
    }
}
