//
//  FileSystemPhotosStoreTests.swift
//  MemapDataTests
//
//  Created by Vu Dinh Phong on 02/04/2026.
//

import XCTest

class FileSystemPhotosStore {
    
    func retrieve(from url: URL, completion: @escaping ([URL]) -> Void) {
        completion([])
    }
    
}

final class FileSystemPhotosStoreTests: XCTestCase {
    
    // MARK: - Retrievals
    
    func test_retrieve_deliversEmptyOnEmptyFolder() {
        let sut = FileSystemPhotosStore()
        trackForMemoryLeaks(sut)
        let storeURL = testSpecificPlacePhotosStoreURL()
        
        let expectation = expectation(description: "Waiting for completion to be invoked")
        sut.retrieve(from: storeURL) { urls in
            
            XCTAssertEqual(urls, [])
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Insertions
    
    
    
    // MARK: - Deletions
    
    
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> FileSystemPhotosStore {
        let sut = FileSystemPhotosStore()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func testSpecificPlacePhotosStoreURL() -> URL {
        return documentDirectory()
            .appendingPathComponent("Memap")
            .appendingPathComponent("photos")
            .appendingPathComponent("a_place_id")
    }
    
    private func documentDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
