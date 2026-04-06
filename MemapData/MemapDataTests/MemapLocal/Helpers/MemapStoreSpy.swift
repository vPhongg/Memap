//
//  MemapStoreSpy.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 27/02/2026.
//


import Foundation
import MemapData

final class MemapStoreSpy: PlaceStore {
    
    enum ReceivedMessage: Equatable {
        case insert(_ item: LocalPlaceInfo)
        case retrieve
        case delete(_ item: LocalPlaceInfo)
    }
    
    enum RetrieveResult {
        case success([LocalPlaceInfo])
        case failure(Error)
    }
    
    enum InsertionResult {
        case success
        case failure(Error)
    }
    
    enum DeletionResult {
        case success
        case failure(Error)
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    var retrieveResult: RetrieveResult = .success([])
    var insertionResult: InsertionResult = .success
    var deletionResult: InsertionResult = .success
    
    func retrieve() async throws -> [LocalPlaceInfo] {
        receivedMessages.append(.retrieve)
        
        switch retrieveResult {
        case .success(let places):
            return places
        case .failure(let error):
            throw error
        }
    }
    
    func insert(_ place: LocalPlaceInfo) async throws {
        receivedMessages.append(.insert(place))
        
        if case .failure(let error) = insertionResult {
            throw error
        }
    }
    
    func delete(_ place: LocalPlaceInfo) async throws {
        receivedMessages.append(.delete(place))
        
        if case .failure(let error) = deletionResult {
            throw error
        }
    }
}
