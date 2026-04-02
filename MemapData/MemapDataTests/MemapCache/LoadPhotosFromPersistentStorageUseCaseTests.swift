//
//  LoadPhotosFromPersistentStorageUseCaseTests.swift
//  MemapDataTests
//
//  Created by Vu Dinh Phong on 02/04/2026.
//

import XCTest
import MemapData

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
        
        expect(sut, toCompleteWith: .failure(anyNSError()), when: {
            store.completeRetrieval(with: anyNSError())
        })
        
    }
    
    func test_load_deliversNoPhotosOnEmptyFolder() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .success([]), when: {
            store.completeRetrieval(with: [])
        })
    }
    
    // MARK: - Helpers
    
    private func expect(
        _ sut: PhotosPersistentLoader,
        toCompleteWith expectedResult: PhotosLoader.RetrievalResult,
        when action: () -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let expectation = expectation(description: "Waiting for completion to be invoke")
        
        sut.load(from: anyPhotosPath()) { receivedResult in
            
            switch (receivedResult, expectedResult) {
            case(.success(let receivedURLs), .success(let expectedURLs)):
                XCTAssertEqual(receivedURLs, expectedURLs, file: file, line: line)
                
            case(.failure(let receivedError), .failure(let expectedError)):
                XCTAssertEqual(receivedError as NSError, expectedError as NSError, file: file, line: line)
                
            default:
                XCTFail("Expected \(expectedResult), but got \(receivedResult) instead")
            }
            
            expectation.fulfill()
        }
        
        action()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
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
