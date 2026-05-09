//
//  PhotoPersistentManager.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 02/04/2026.
//

import Foundation

public class PhotoPersistentManager: PhotoLoadable {
    let store: PhotoStore
    
    public init(store: PhotoStore) {
        self.store = store
    }
    
    public func load(from path: URL, completion: @escaping RetrievalCompletion) {
        store.retrieve(from: path) { result in
            switch result {
            case .success(let urls):
                completion(.success(urls))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension PhotoPersistentManager: PhotoSavable {
    public func save(_ photos: [Photo], toDirectory url: URL) async throws {
        typealias LoadContinuation = CheckedContinuation<Void, Swift.Error>
        try await withCheckedThrowingContinuation { (continuation: LoadContinuation) in
            store.insert(photos.toLocalPhotos(), toDirectory: url) { result in
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
            LocalPhoto(name: item.id, jpegData: item.jpegData)
        }
    }
}
