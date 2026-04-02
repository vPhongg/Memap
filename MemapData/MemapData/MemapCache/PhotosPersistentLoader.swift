//
//  PhotosPersistentLoader.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 02/04/2026.
//

import Foundation

public class PhotosPersistentLoader {
    public typealias RetrievalResult = (Result<[URL], Error>)
    public typealias RetrievalCompletion = (RetrievalResult) -> Void
    
    let store: PhotosStore
    
    public init(store: PhotosStore) {
        self.store = store
    }
    
    public func load(from path: String, completion: @escaping RetrievalCompletion) {
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
