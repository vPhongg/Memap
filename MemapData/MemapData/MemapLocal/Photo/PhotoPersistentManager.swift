//
//  PhotoPersistentManager.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 02/04/2026.
//

import Foundation

public class PhotoPersistentManager: PhotoLoadable {
    
    enum PhotoManagerError: Error {
        case placeResourceDirectoryNotFound
        case documentDirectoryNotFound
    }
    
    
    let store: PhotoStore
    let fileManager = FileManager.default
    
    public init(store: PhotoStore) {
        self.store = store
    }
    
    public func loadImages(for placeID: String, completion: @escaping RetrievalCompletion) {
        do {
            let placePath = try self.placeResourcesDirectoryURL().appending(path: placeID)
            store.retrieve(from: placePath) { result in
                switch result {
                case .success(let urls):
                    completion(.success(urls))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(PhotoManagerError.placeResourceDirectoryNotFound))
        }
    }
    
    private func basedTrashURL() throws -> URL {
        return try documentDirectory().appending(path: "Memap").appending(path: ".trash")
    }
    
    private func documentDirectory() throws -> URL {
        if let docDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            return docDir
        } else {
            throw PhotoManagerError.documentDirectoryNotFound
        }
    }
    
    private func placeResourcesDirectoryURL() throws -> URL {
        return try documentDirectory()
            .appendingPathComponent("Memap")
            .appendingPathComponent("resources")
    }
}

extension PhotoPersistentManager: PhotoSavable {
    public func save(_ photos: [Photo], placeID: String) async throws {
        typealias LoadContinuation = CheckedContinuation<Void, Swift.Error>
        try await withCheckedThrowingContinuation { (continuation: LoadContinuation) in
            store.insert(photos.toLocalPhotos(), placeID: placeID) { result in
                switch result {
                case .success():
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

extension Array where Element == Photo {
    func toLocalPhotos() ->  [LocalPhoto] {
        self.map { item in
            LocalPhoto(name: item.name, jpegData: item.jpegData)
        }
    }
}
