//
//  PhotosStoreSpy.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 02/04/2026.
//

import Foundation
import MemapData

class PhotosStoreSpy: PhotosStore {
    enum ReceivedMessage: Equatable {
        case retrieve
    }
    
    private(set) var receivedMessages: [ReceivedMessage] = []
    
    private var retrievalCompletions = [RetrievalCompletion]()
    
    func retrieve(from path: String, completion: @escaping RetrievalCompletion) {
        retrievalCompletions.append(completion)
        receivedMessages.append(.retrieve)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    
    func completeRetrieval(with urls: [URL], at index: Int = 0) {
        retrievalCompletions[index](.success(urls))
    }
}
