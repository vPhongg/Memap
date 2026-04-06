//
//  PhotosPersistentLoader.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 02/04/2026.
//

import Foundation

public class PhotosPersistentLoader: PhotosLoader {
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
