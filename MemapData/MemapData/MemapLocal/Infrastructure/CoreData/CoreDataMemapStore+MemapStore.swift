//
//  CoreDataMemapStore+MemapStore.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 27/02/2026.
//


import CoreData

extension CoreDataMemapStore: PlaceStore {
    
    public func insert(_ place: LocalPlaceInfo) async throws {
        try ManagedPlaceInfo.insert(place, in: context)
    }
    
    public func retrieve() async throws -> [LocalPlaceInfo] {
        try ManagedPlaceInfo.fetch(in: context).localPlaces
    }
    
    public func delete(_ place: LocalPlaceInfo) async throws {
        try ManagedPlaceInfo.delete(by: place.id, in: context)
    }
    
}
