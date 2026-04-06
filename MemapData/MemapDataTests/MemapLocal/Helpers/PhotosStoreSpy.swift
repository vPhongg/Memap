//
//  PhotosStoreSpy.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 02/04/2026.
//

import Foundation
import MemapData

class PhotosStoreSpy: PhotoStore {

    enum ReceivedMessage: Equatable {
        case retrieve
    }
    
    private(set) var receivedMessages: [ReceivedMessage] = []
    
    private var retrievalCompletions = [RetrievalCompletion]()
    
    func retrieve(from path: URL, completion: @escaping RetrievalCompletion) {
        retrievalCompletions.append(completion)
        receivedMessages.append(.retrieve)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    
    func completeRetrieval(with urls: [URL], at index: Int = 0) {
        retrievalCompletions[index](.success(urls))
    }
    
    func insert(_ photos: [MemapData.Photo], toDirectory url: URL, completion: @escaping InsertionCompletion) {
        //
    }
    
    func delete(_ fileURLs: [URL], completion: @escaping DeletionCompletion) {
        //
    }
    
    func deleteDirectory(at url: URL, completion: @escaping DeletionCompletion) {
        //
    }
}
