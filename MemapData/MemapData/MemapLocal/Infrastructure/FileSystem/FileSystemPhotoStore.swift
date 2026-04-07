//
//  FileSystemPhotoStore.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 06/04/2026.
//

import Foundation

public class FileSystemPhotoStore: PhotoStore {
    enum PhotoStoreError: Swift.Error {
        case documentDirectoryNotFound
    }
    
    let fileManager = FileManager.default
    
    public init() {}
    
    private func basedTrashURL() throws -> URL {
        return try documentDirectory().appending(path: "Memap").appending(path: ".trash")
    }
    
    private func documentDirectory() throws -> URL {
        if let docDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            return docDir
        } else {
            throw PhotoStoreError.documentDirectoryNotFound
        }
    }
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
    
    public func moveToTrash(at srcURL: URL, completion: @escaping MovingCompletion) {
        do {
            let result = getSplitedURL(from: srcURL)
            let trashURL = try basedTrashURL()
            if srcURL.isDirectory {
                try fileManager.createDirectory(at: trashURL, withIntermediateDirectories: true)
                let destination = trashURL.appendingPathComponent(result.lastComponent)
                try fileManager.moveItem(at: srcURL, to: destination)
            } else {
                let trashURLToCreate = trashURL.appending(path: result.secondLastComponent)
                try fileManager.createDirectory(at: trashURLToCreate, withIntermediateDirectories: true)
                let destination = trashURLToCreate.appendingPathComponent(result.lastComponent)
                try fileManager.moveItem(at: srcURL, to: destination)
            }
            
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
        
        func getSplitedURL(from url: URL) -> (secondLastComponent: String, lastComponent: String) {
            let specificComponent = url.pathComponents.suffix(2)
            let secondLastComponent = specificComponent.first ?? ""
            let lastComponent = specificComponent.last ?? ""
            return (secondLastComponent, lastComponent)
        }
    }
}

private extension URL {
    var isDirectory: Bool {
        var isDir: ObjCBool = false
        FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
        return isDir.boolValue
    }
}
