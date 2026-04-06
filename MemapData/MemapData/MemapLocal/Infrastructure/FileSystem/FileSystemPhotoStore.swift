//
//  FileSystemPhotoStore.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 06/04/2026.
//

import Foundation

public class FileSystemPhotoStore: PhotoStore {
    let fileManager = FileManager.default
    
    public init() {}
}

// MARK: - Retrievals

extension FileSystemPhotoStore {
    public typealias RetrievalResult = Swift.Result<[URL], Error>
    public typealias RetrievalCompletion = (RetrievalResult) -> Void
    
    public func retrieve(from url: URL, completion: @escaping RetrievalCompletion) {
        do {
            let contents = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            completion(.success(contents))
        } catch {
            completion(.failure(error))
        }
    }
}

// MARK: - Insertions

extension FileSystemPhotoStore {
    public typealias InsertionResult = Swift.Result<Void, Error>
    public typealias InsertionCompletion = (InsertionResult) -> Void
    
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
}


// MARK: - Deletions

extension FileSystemPhotoStore {
    public typealias DeletionResult = Swift.Result<Void, Error>
    public typealias DeletionCompletion = (DeletionResult) -> Void
    
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

// MARK: - Moving files

extension FileSystemPhotoStore {
    public typealias MovingResult = Swift.Result<Void, Error>
    public typealias MovingCompletion = (MovingResult) -> Void
    
    public func move(
        at srcURL: URL,
        to dstURL: URL,
        completion: @escaping MovingCompletion
    ) {
        do {
            try fileManager.createDirectory(at: dstURL, withIntermediateDirectories: true)

            let destination = dstURL.appendingPathComponent(srcURL.lastPathComponent)
            try fileManager.moveItem(at: srcURL, to: destination)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    private func getPhotoFullTrashURL(baseTrashURL: URL, srcURL: URL) -> URL {
        return baseTrashURL.appending(path: getPhotoURL(from: srcURL))
        
        func getPhotoURL(from fullURL: URL) -> String {
            let components = fullURL.pathComponents
            return components.suffix(2).joined(separator: "/")
        }
    }
    
}
