//
//  CoreDataMemapStore+MemapStore.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 27/02/2026.
//


import CoreData

extension CoreDataMemapStore: PlaceStore {
    
    public func insert(_ place: LocalPlace) async throws {
        try ManagedPlace.insert(place, in: context)
    }
    
    public func retrieve() async throws -> [LocalPlace] {
        try ManagedPlace.fetch(in: context).localPlaces
    }
    
    public func delete(_ place: LocalPlace) async throws {
        try ManagedPlace.delete(by: place.id, in: context)
    }
    
}
