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
    
    typealias RetrievalResult = Swift.Result<[URL], Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    
    typealias InsertionResult = Swift.Result<Void, Error>
    typealias InsertionCompletion = (InsertionResult) -> Void
    
    typealias DeletionResult = Swift.Result<Void, Error>
    typealias DeletionCompletion = (DeletionResult) -> Void
    
    func retrieve(from url: URL, completion: @escaping RetrievalCompletion) {
        do {
            let contents = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            completion(.success(contents))
        } catch {
            completion(.failure(error))
        }
    }
    
    func insert(_ photos: [Photo], toDirectory url: URL, completion: @escaping InsertionCompletion) {
        do {
            try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
            for photo in photos {
                let fileURL = url.appendingPathComponent(photo.name)
                try photo.jpegData.write(to: fileURL)
            }
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func delete(_ fileURLs: [URL], completion: @escaping DeletionCompletion) {
        for fileURL in fileURLs {
            do {
                try fileManager.removeItem(at: fileURL)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func deleteDirectory(at url: URL, completion: @escaping DeletionCompletion) {
        guard fileManager.fileExists(atPath: url.path) else {
            return completion(.success(()))
        }
        
        do {
            try fileManager.removeItem(at: url)
            completion(.success(()))
        } catch {
            completion(.failure(error))
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
        let directoryURL = testSpecificPlacePhotosDirectoryURL()
        
        let expectation = expectation(description: "Waiting for completion to be invoked")
        sut.retrieve(from: directoryURL) { result in
            if case .success(let receivedURLs) = result {
                XCTAssertEqual(receivedURLs, [])
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_retrieve_deliversPhotosOnNonEmptyFolder() {
        let sut = makeSUT()
        let directoryURL = testSpecificPlacePhotosDirectoryURL()
        let photos = [anyPhoto(), anyPhoto(), anyPhoto(), anyPhoto()]
        
        let insertExpectation = expectation(description: "Waiting for completion to be invoked")
        sut.insert(photos, toDirectory: directoryURL) { _ in insertExpectation.fulfill() }
        wait(for: [insertExpectation], timeout: 1.0)
        
        let expectation = expectation(description: "Waiting for completion to be invoked")
        sut.retrieve(from: directoryURL) { result in
            if case .success(let receivedURLs) = result {
                XCTAssertEqual(receivedURLs.count, 4)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Insertions
    
    func test_insert_deliverNoError() {
        let sut = makeSUT()
        let directoryURL = testSpecificPlacePhotosDirectoryURL()
        
        let insertExpectation = expectation(description: "Waiting for completion to be invoked")
        sut.insert([anyPhoto()], toDirectory: directoryURL) { result in
            switch result {
            case .success():
                break
            case .failure( let error):
                XCTFail("Expected success but got error: \(error) instead")
            }
            insertExpectation.fulfill()
        }
        wait(for: [insertExpectation], timeout: 1.0)
    }
    
    func test_insert_deliverNoErrorOnMultiplePhotos() {
        let sut = makeSUT()
        let directoryURL = testSpecificPlacePhotosDirectoryURL()
        let photos = [anyPhoto(), anyPhoto(), anyPhoto(), anyPhoto(), anyPhoto()]
                
        let insertExpectation = expectation(description: "Waiting for completion to be invoked")
        sut.insert(photos, toDirectory: directoryURL) { result in
            switch result {
            case .success():
                break
            case .failure( let error):
                XCTFail("Expected success but got error: \(error) instead")
            }
            insertExpectation.fulfill()
        }
        wait(for: [insertExpectation], timeout: 1.0)
    }
    
    
    // MARK: - Deletions
    
    func test_delete_deliverNoErrorOnSingleDeletion() throws {
        let sut = makeSUT()
        let photo = anyPhoto()
        let directoryURL = testSpecificPlacePhotosDirectoryURL()
        
        let insertExpectation = expectation(description: "Waiting for completion to be invoked")
        sut.insert([photo], toDirectory: directoryURL) { _ in insertExpectation.fulfill() }
        wait(for: [insertExpectation], timeout: 1.0)
        
        let filePathToDetele = directoryURL.appendingPathComponent(photo.name)
        
        let expectation = expectation(description: "Waiting for completion to be invoked")
        sut.delete([filePathToDetele]) { result in
            switch result {
            case .success():
                break
            case .failure( let error):
                XCTFail("Expected success but got error: \(error) instead")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_delete_deliverNoErrorIfDirectoryNotExist() {
        let sut = makeSUT()
        let url = testSpecificPlacePhotosDirectoryURL()
        
        let expectation = expectation(description: "Waiting for completion to be invoked")
        sut.deleteDirectory(at: url) { result in
            switch result {
            case .success():
                break
            case .failure( let error):
                XCTFail("Expected success but got error: \(error) instead")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_delete_deliverNoErrorIfDirectoryExist() {
        let sut = makeSUT()
        let url = testSpecificPlacePhotosDirectoryURL()
        let photos = [anyPhoto(), anyPhoto(), anyPhoto(), anyPhoto(), anyPhoto()]
        
        let insertExpectation = expectation(description: "Waiting for completion to be invoked")
        sut.insert(photos, toDirectory: url) { _ in insertExpectation.fulfill() }
        wait(for: [insertExpectation], timeout: 1.0)
        
        let expectation = expectation(description: "Waiting for completion to be invoked")
        sut.deleteDirectory(at: url) { result in
            switch result {
            case .success():
                break
            case .failure( let error):
                XCTFail("Expected success but got error: \(error) instead")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
        
    // MARK: - Helpers
    
    private func anyPhoto() -> Photo {
        let photoName = UUID().uuidString + ".jpg"
        let fakeJpegData = Data([1, 2, 4])
        
        return Photo(name: photoName, jpegData: fakeJpegData)
    }
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> FileSystemPhotosStore {
        let sut = FileSystemPhotosStore()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func testSpecificPlacePhotosDirectoryURL() -> URL {
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
        try? FileManager.default.removeItem(at: testSpecificPlacePhotosDirectoryURL())
    }
}
