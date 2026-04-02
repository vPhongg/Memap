//
//  LoadImagesFromFileSystemUseCaseTests.swift
//  MemapDataTests
//
//  Created by Vu Dinh Phong on 02/04/2026.
//

import XCTest

class PhotosStoreSpy {
    enum ReceivedMessage: Equatable {
        case retrieve
    }
    
    private(set) var receivedMessages: [ReceivedMessage] = []
}

class PhotosPersistentLoader {
    let store: PhotosStoreSpy
    
    init(store: PhotosStoreSpy) {
        self.store = store
    }
}

final class LoadPhotosFromPersistentStorageUseCaseTests: XCTestCase {
    
    func test_init_deliversNoMessageUponCreation() {
        
        let store = PhotosStoreSpy()
        let _ = PhotosPersistentLoader(store: store)
        
        XCTAssertEqual(store.receivedMessages, [])
    }

}
