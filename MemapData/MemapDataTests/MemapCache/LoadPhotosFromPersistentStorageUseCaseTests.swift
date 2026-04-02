//
//  LoadPhotosFromPersistentStorageUseCaseTests.swift
//  MemapDataTests
//
//  Created by Vu Dinh Phong on 02/04/2026.
//

import XCTest

class PhotosStoreSpy {
    typealias RetrievalCompletion = (Error) -> Void
    
    enum ReceivedMessage: Equatable {
        case retrieve
    }
    
    private(set) var receivedMessages: [ReceivedMessage] = []
    
    var retrievalCompletions = [RetrievalCompletion]()
    
    func retrieve(from photosPath: String, completion: @escaping RetrievalCompletion) {
        retrievalCompletions.append(completion)
        receivedMessages.append(.retrieve)
    }
}

class PhotosPersistentLoader {
    let store: PhotosStoreSpy
    
    init(store: PhotosStoreSpy) {
        self.store = store
    }
    
    func load(from photosPath: String, completion: @escaping (Error) -> Void) {
        store.retrieve(from: photosPath, completion: completion)
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
        
        sut.load(from: anyPhotosPath()) { error in
            
            XCTAssertEqual(error as NSError, anyNSError())
            
            expectation.fulfill()
        }
        
        store.retrievalCompletions[0](anyNSError())
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
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
