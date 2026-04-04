//
//  FileSystemPhotosStoreTests.swift
//  MemapDataTests
//
//  Created by Vu Dinh Phong on 02/04/2026.
//

import XCTest

struct Photo {
    let name: String
    let jpegData: Data
}

class FileSystemPhotosStore {
    let fileManager = FileManager.default
    
    func retrieve(from url: URL, completion: @escaping ([URL]) -> Void) {
        completion([])
    }
    
    func insert(_ photos: [Photo], toDirectory url: URL) throws {
        try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
        
        for photo in photos {
            let fileURL = url.appendingPathComponent(photo.name)
            try photo.jpegData.write(to: fileURL)
        }
    }
    
}

final class FileSystemPhotosStoreTests: XCTestCase {
    
    override func setUp() {
        emptyPhotosDirectory()
    }
    
    override func tearDown() {
        emptyPhotosDirectory()
    }
    
    // MARK: - Retrievals
    
    func test_retrieve_deliversEmptyOnEmptyFolder() {
        let sut = makeSUT()
        let storeURL = testSpecificPlacePhotosStoreURL()
        
        let expectation = expectation(description: "Waiting for completion to be invoked")
        sut.retrieve(from: storeURL) { urls in
            
            XCTAssertEqual(urls, [])
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Insertions
    
    func test_insert_deliverNoErrory() {
        let sut = makeSUT()
        let directoryURL = testSpecificPlacePhotosStoreURL()
        
        XCTAssertNoThrow(try sut.insert([anyPhoto()], toDirectory: directoryURL))
    }
    
    func test_insert_deliverNoErrorOnMultiplePhotos() {
        let sut = makeSUT()
        let directoryURL = testSpecificPlacePhotosStoreURL()
        let photos = [anyPhoto(), anyPhoto(), anyPhoto(), anyPhoto(), anyPhoto()]
        
        XCTAssertNoThrow(try sut.insert(photos, toDirectory: directoryURL))
    }
    
    
    // MARK: - Deletions
        
    // MARK: - Helpers
    
    private func anyPhoto() -> Photo {
        let photoName = UUID().uuidString + ".jpg"
        let image = UIImage(systemName: "square.and.arrow.up")!
        let jpegData = image.jpegData(compressionQuality: 0.8)!
        
        return Photo(name: photoName, jpegData: jpegData)
    }
    
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
    
    private func emptyPhotosDirectory() {
        deletePhotos()
    }
    
    private func deletePhotos() {
        try? FileManager.default.removeItem(at: testSpecificPlacePhotosStoreURL())
    }
}
