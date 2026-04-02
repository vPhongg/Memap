//
//  PhotosLoader.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 02/04/2026.
//

import Foundation

public protocol PhotosLoader {
    typealias RetrievalResult = (Result<[URL], Error>)
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    
    func load(from path: String, completion: @escaping RetrievalCompletion)
}
