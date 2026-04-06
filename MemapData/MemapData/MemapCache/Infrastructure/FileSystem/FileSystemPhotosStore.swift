//
//  FileSystemPhotosStore.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 06/04/2026.
//

import Foundation

public class FileSystemPhotosStore {
    let fileManager = FileManager.default
    
    public typealias RetrievalResult = Swift.Result<[URL], Error>
    public typealias RetrievalCompletion = (RetrievalResult) -> Void
    
    public typealias InsertionResult = Swift.Result<Void, Error>
    public typealias InsertionCompletion = (InsertionResult) -> Void
    
    public typealias DeletionResult = Swift.Result<Void, Error>
    public typealias DeletionCompletion = (DeletionResult) -> Void
    
    public init() {}
    
    public func retrieve(from url: URL, completion: @escaping RetrievalCompletion) {
        do {
            let contents = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            completion(.success(contents))
        } catch {
            completion(.failure(error))
        }
    }
    
    public func insert(_ photos: [Photo], toDirectory url: URL, completion: @escaping InsertionCompletion) {
        do {
            try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
            for photo in photos {
                let fileURL = url.appendingPathComponent(photo.name)
                try photo.jpegData.write(to: fileURL)
            }
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    public func delete(_ fileURLs: [URL], completion: @escaping DeletionCompletion) {
        for fileURL in fileURLs {
            do {
                try fileManager.removeItem(at: fileURL)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func deleteDirectory(at url: URL, completion: @escaping DeletionCompletion) {
        guard fileManager.fileExists(atPath: url.path) else {
            return completion(.success(()))
        }
        
        do {
            try fileManager.removeItem(at: url)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}
