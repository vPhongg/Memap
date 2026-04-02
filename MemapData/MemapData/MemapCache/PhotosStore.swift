//
//  PhotosStore.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 02/04/2026.
//

import Foundation

public protocol PhotosStore {
    typealias RetrievalResult = Result<[URL], Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    
    func retrieve(from path: String, completion: @escaping RetrievalCompletion)
}
