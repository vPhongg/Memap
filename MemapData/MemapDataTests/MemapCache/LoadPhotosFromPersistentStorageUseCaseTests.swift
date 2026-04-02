//
//  LoadPhotosFromPersistentStorageUseCaseTests.swift
//  MemapDataTests
//
//  Created by Vu Dinh Phong on 02/04/2026.
//

import XCTest

class PhotosStoreSpy {
    typealias RetrievalCompletion = (Result<[URL], Error>) -> Void
    
    enum ReceivedMessage: Equatable {
        case retrieve
    }
    
    private(set) var receivedMessages: [ReceivedMessage] = []
    
    var retrievalCompletions = [RetrievalCompletion]()
    
    func retrieve(from path: String, completion: @escaping RetrievalCompletion) {
        retrievalCompletions.append(completion)
        receivedMessages.append(.retrieve)
    }
}

class PhotosPersistentLoader {
    let store: PhotosStoreSpy
    
    init(store: PhotosStoreSpy) {
        self.store = store
    }
    
    func load(from path: String, completion: @escaping (Result<[URL], Error>) -> Void) {
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

final class LoadPhotosFromPersistentStorageUseCaseTests: XCTestCase {
    
    func test_init_deliversNoMessageUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestsPhotosRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.load(from: anyPhotosPath()) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_failedOnRetrievalError() {
        let (sut, store) = makeSUT()
        
        let expectation = expectation(description: "Waiting for completion to be invoke")
        
        sut.load(from: anyPhotosPath()) { result in
            
            if case .failure(let error) = result {
                XCTAssertEqual(error as NSError, anyNSError())
            }
            
            expectation.fulfill()
        }
        
        store.retrievalCompletions[0](.failure(anyNSError()))
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_load_deliversNoPhotosOnEmptyFolder() {
        let (sut, store) = makeSUT()
        
        let expectation = expectation(description: "Waiting for completion to be invoke")
        
        sut.load(from: anyPhotosPath()) { result in
            
            if case .success(let urls) = result {
                XCTAssertEqual(urls, [])
            }
            
            expectation.fulfill()
        }
        
        store.retrievalCompletions[0](.success([]))
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func anyPhotosPath() -> String {
        return "any/photos/path"
    }
    
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: PhotosPersistentLoader, store: PhotosStoreSpy) {
        let store = PhotosStoreSpy()
        let sut = PhotosPersistentLoader(store: store)
        
        return (sut, store)
    }
    
}
