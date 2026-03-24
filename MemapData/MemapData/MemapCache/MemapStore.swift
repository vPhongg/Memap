//
//  MemapData.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 26/02/2026.
//

import Foundation

public protocol MemapStore {
    
    /// The result can be invoked in any threads
    /// Clients are responsible to dispatch to appropriate threads, if need
    /// - Returns: [LocalPlaceInfo] or throw error
    func retrieve() async throws -> [LocalPlaceInfo]
    
    /// The result can be invoked in any threads
    /// Clients are responsible to dispatch to appropriate threads, if need
    /// - Parameters:
    ///   - place: LocalPlaceInfo
    /// - Returns: Void or throw error
    func insert(_ place: LocalPlaceInfo) async throws
    
    
    /// The result can be invoked in any threads
    /// Clients are responsible to dispatch to appropriate threads, if need
    /// - Parameters:
    ///   - place: LocalPlaceInfo
    /// - Returns: Void or throw error
    func delete(_ place: LocalPlaceInfo) async throws
}
