//
//  FileSystemPhotoStore.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 06/04/2026.
//

import Foundation

public protocol FileManagerProtocol {
    func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL]
    func contentsOfDirectory(at url: URL, includingPropertiesForKeys keys: [URLResourceKey]?, options mask: FileManager.DirectoryEnumerationOptions) throws -> [URL]
    func removeItem(at URL: URL) throws
    func moveItem(at srcURL: URL, to dstURL: URL) throws
    func fileExists(atPath path: String) -> Bool
    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]?) throws
}

extension FileManager: FileManagerProtocol {}

public class FileSystemPhotoStore: PhotoStore {
    public enum PhotoStoreError: Swift.Error {
        case documentDirectoryNotFound
        case failedToRemoveItem
    }
    
    let fileManager: FileManagerProtocol
    
    public init(fileManager: FileManagerProtocol = FileManager.default) {
        self.fileManager = fileManager
    }
    
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
            let contents = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
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
            try self.createDirectory(for: url)
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
                completion(.failure(PhotoStoreError.failedToRemoveItem))
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
            completion(.failure(PhotoStoreError.failedToRemoveItem))
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
            try self.createDirectory(for: dstURL)
            
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
                try self.createDirectory(for: trashURL)
                let destination = trashURL.appendingPathComponent(result.lastComponent)
                try fileManager.moveItem(at: srcURL, to: destination)
            } else {
                let trashURLToCreate = trashURL.appending(path: result.secondLastComponent)
                try self.createDirectory(for: trashURLToCreate)
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

// MARK: - Creations

extension FileSystemPhotoStore {
    public func createDirectory(for url: URL) throws {
        try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    }
}

private extension URL {
    var isDirectory: Bool {
        var isDir: ObjCBool = false
        FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
        return isDir.boolValue
    }
}
