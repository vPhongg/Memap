//
//  PhotoLoadable.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 02/04/2026.
//

import Foundation

public protocol PhotoLoadable {
    typealias RetrievalResult = (Result<[URL], Error>)
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    
    func loadImages(for placeID: String, completion: @escaping RetrievalCompletion)
}
