//
//  PlaceStore.swift
//  PlaceStore
//
//  Created by Vu Dinh Phong on 26/02/2026.
//

import Foundation

public protocol PlaceStore {
    
    /// The result can be invoked in any threads
    /// Clients are responsible to dispatch to appropriate threads, if need
    /// - Returns: [LocalPlace] or throw error
    func retrieve() async throws -> [LocalPlace]
    
    /// The result can be invoked in any threads
    /// Clients are responsible to dispatch to appropriate threads, if need
    /// - Parameters:
    ///   - place: LocalPlace
    /// - Returns: Void or throw error
    func insert(_ place: LocalPlace) async throws
    
    
    /// The result can be invoked in any threads
    /// Clients are responsible to dispatch to appropriate threads, if need
    /// - Parameters:
    ///   - place: LocalPlace
    /// - Returns: Void or throw error
    func delete(_ place: LocalPlace) async throws
}
