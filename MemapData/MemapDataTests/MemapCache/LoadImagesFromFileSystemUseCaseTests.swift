//
//  LoadImagesFromFileSystemUseCaseTests.swift
//  MemapDataTests
//
//  Created by Vu Dinh Phong on 02/04/2026.
//

import XCTest

class FileSystemStoreSpy {
    enum ReceivedMessage: Equatable {
        case retrieve
    }
    
    private(set) var receivedMessages: [ReceivedMessage] = []
}

class FileSystemLoader {
    let store: FileSystemStoreSpy
    
    init(store: FileSystemStoreSpy) {
        self.store = store
    }
}

final class LoadImagesFromFileSystemUseCaseTests: XCTestCase {
    
    func test_init_deliversNoMessageUponCreation() {
        
        let store = FileSystemStoreSpy()
        let _ = FileSystemLoader(store: store)
        
        XCTAssertEqual(store.receivedMessages, [])
    }

}
