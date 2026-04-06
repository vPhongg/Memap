//
//  PhotoLoader.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 02/04/2026.
//

import Foundation

public protocol PhotoLoader {
    typealias RetrievalResult = (Result<[URL], Error>)
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    
    func load(from path: URL, completion: @escaping RetrievalCompletion)
}
