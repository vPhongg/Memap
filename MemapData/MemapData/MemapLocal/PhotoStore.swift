//
//  PhotoStore.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 02/04/2026.
//

import Foundation

public protocol PhotoStore {
    
    typealias RetrievalResult = Swift.Result<[URL], Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    
    typealias InsertionResult = Swift.Result<Void, Error>
    typealias InsertionCompletion = (InsertionResult) -> Void
    
    typealias DeletionResult = Swift.Result<Void, Error>
    typealias DeletionCompletion = (DeletionResult) -> Void
    
    /// Retrieve all photos urls
    /// - Parameters:
    ///   - url: The directory url that contains a place's photos
    ///   - completion: Result
    func retrieve(from url: URL, completion: @escaping RetrievalCompletion)
    
    /// Add photos to a specify place
    /// - Parameters:
    ///   - photos: The photos to add
    ///   - url: The place id directory url
    ///   - completion: Result
    func insert(_ photos: [Photo], toDirectory url: URL, completion: @escaping InsertionCompletion)
    
    /// The photos urls to delete
    /// - Parameters:
    ///   - fileURLs: The photos urls
    ///   - completion: Result
    func delete(_ fileURLs: [URL], completion: @escaping DeletionCompletion)
    
    /// Delete a whole directory
    /// - Parameters:
    ///   - url: The directory url
    ///   - completion: Result
    func deleteDirectory(at url: URL, completion: @escaping DeletionCompletion)
    
}
