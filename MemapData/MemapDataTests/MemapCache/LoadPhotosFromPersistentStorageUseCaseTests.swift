//
//  LoadPhotosFromPersistentStorageUseCaseTests.swift
//  MemapDataTests
//
//  Created by Vu Dinh Phong on 02/04/2026.
//

import XCTest

struct Photo {}

class PhotosStoreSpy {
    enum ReceivedMessage: Equatable {
        case retrieve
    }
    
    private(set) var receivedMessages: [ReceivedMessage] = []
    
    func retrieve() {
        receivedMessages.append(.retrieve)
    }
}

class PhotosPersistentLoader {
    let store: PhotosStoreSpy
    
    init(store: PhotosStoreSpy) {
        self.store = store
    }
    
    func load(from photoPath: String, completion: @escaping ([Photo]) -> Void) {
        store.retrieve()
    }
}

final class LoadPhotosFromPersistentStorageUseCaseTests: XCTestCase {
    
    func test_init_deliversNoMessageUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestsPhotosRetrieval() {
        let (sut, store) = makeSUT()
        let path = "anypath"
        
        sut.load(from: path) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    // MARK: - Helpers
    
    
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: PhotosPersistentLoader, store: PhotosStoreSpy) {
        let store = PhotosStoreSpy()
        let sut = PhotosPersistentLoader(store: store)
        
        return (sut, store)
    }
    
}
