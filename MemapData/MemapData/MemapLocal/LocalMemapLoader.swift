//
//  LocalMemapLoader.swift
//  LocalMemapLoader
//
//  Created by Vu Dinh Phong on 25/02/2026.
//


import Foundation

public final class LocalMemapLoader {
    private let store: PlaceStore
    
    public init(store: PlaceStore) {
        self.store = store
    }
}

extension LocalMemapLoader: MemapLoader {
    public func load() async throws -> [PlaceInfo] {
        return try await store.retrieve().toModels()
    }
}

extension LocalMemapLoader: MemapPersistence {
    public func save(_ place: PlaceInfo) async throws {
        try await store.insert(place.toLocal())
    }
}

extension LocalMemapLoader: MemapDelete {
    public func delete(_ place: PlaceInfo) async throws {
        try await store.delete(place.toLocal())
    }
}
