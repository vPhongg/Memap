//
//  FileSystemPhotosStoreTests.swift
//  MemapDataTests
//
//  Created by Vu Dinh Phong on 02/04/2026.
//

import XCTest
import MemapData

class MockFileManager: FileManagerProtocol {
    func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
        return []
    }
    
    func contentsOfDirectory(at url: URL, includingPropertiesForKeys keys: [URLResourceKey]?, options mask: FileManager.DirectoryEnumerationOptions) throws -> [URL] {
        return []
    }
    
    func removeItem(at URL: URL) throws {
        throw FileSystemPhotoStore.PhotoStoreError.failedToRemoveItem
    }
    
    func moveItem(at srcURL: URL, to dstURL: URL) throws {
        //
    }
    
    func fileExists(atPath path: String) -> Bool {
        return true
    }
    
    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]?) throws {
        //
    }
}

final class FileSystemPhotosStoreTests: XCTestCase {
    
    override func setUp() {
        emptyPhotosDirectory()
        emptyAnyDestDirectoryURL()
        emptyTrashDirectoryURL()
    }
    
    override func tearDown() {
        emptyPhotosDirectory()
        emptyAnyDestDirectoryURL()
        emptyTrashDirectoryURL()
    }
    
    // MARK: - Retrievals
    
    func test_retrieve_deliversEmptyOnEmptyDirectory() throws {
        let sut = makeSUT()
        let directoryURL = testSpecificPlaceResourcesDirectoryURL()
        
        try sut.createDirectory(for: directoryURL)
        
        let expectation = expectation(description: "Waiting for completion to be invoked")
        sut.retrieve(from: directoryURL) { result in
            if case .success(let receivedURLs) = result {
                XCTAssertEqual(receivedURLs, [])
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_retrieve_deliversPhotosOnNonEmptyDirectory() {
        let sut = makeSUT()
        let directoryURL = testSpecificPlaceResourcesDirectoryURL()
        let photos = [anyPhoto(), anyPhoto(), anyPhoto(), anyPhoto()]
        
        insert(photos, to: sut, at: directoryURL)
        
        let expectation = expectation(description: "Waiting for completion to be invoked")
        sut.retrieve(from: directoryURL) { result in
            if case .success(let receivedURLs) = result {
                XCTAssertEqual(receivedURLs.count, 4)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_retrieve_deliversErrorOnNonExistPlaceDirectory() {
        let sut = makeSUT()
        let directoryURL = testSpecificPlaceResourcesDirectoryURL()
        
        var error: Error?
        let expectation = expectation(description: "Waiting for completion to be invoked")
        sut.retrieve(from: directoryURL) { result in
            if case .failure(let receivedError) = result {
                error = receivedError
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertNotNil(error)
    }
    
    // MARK: - Insertions
    
    func test_insert_deliverNoError() {
        let sut = makeSUT()
        let directoryURL = testSpecificPlaceResourcesDirectoryURL()
        
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
        let directoryURL = testSpecificPlaceResourcesDirectoryURL()
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
        let directoryURL = testSpecificPlaceResourcesDirectoryURL()
        
        insert([photo], to: sut, at: directoryURL)
        
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
        let url = testSpecificPlaceResourcesDirectoryURL()
        
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
        let url = testSpecificPlaceResourcesDirectoryURL()
        let photos = [anyPhoto(), anyPhoto(), anyPhoto(), anyPhoto(), anyPhoto()]
        
        insert(photos, to: sut, at: url)
        
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
    
    func test_deleteDirectory_deliverErrorOnRemoveItemError() {
        let sut = makeSUT(fileManager: MockFileManager())
        
        let url = testSpecificPlaceResourcesDirectoryURL()
        let photos = [anyPhoto(), anyPhoto(), anyPhoto(), anyPhoto(), anyPhoto()]
        
        insert(photos, to: sut, at: url)
        
        let expectation = expectation(description: "Waiting for completion to be invoked")
        sut.deleteDirectory(at: url) { result in
            switch result {
            case .success():
                XCTFail("Expected failure but got error: \(result) instead")
            case .failure( let error):
                XCTAssertEqual(error as? FileSystemPhotoStore.PhotoStoreError, FileSystemPhotoStore.PhotoStoreError.failedToRemoveItem)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Moving Files
    
    func test_move_deliverNoErrorMoveFileToAnyDestination() {
        let sut = makeSUT()
        let photo = anyPhoto()
        let photoURL = testSpecificPlaceResourcesDirectoryURL().appendingPathComponent(photo.name)
        let photos = [anyPhoto(), anyPhoto(), photo, anyPhoto(), anyPhoto()]
        let url = testSpecificPlaceResourcesDirectoryURL()
        let dstDirectory = testAnyDestDirectoryURL()
        
        insert(photos, to: sut, at: url)
        
        let moveExpectation = expectation(description: "Waiting for completion to be invoked")
        sut.move(at: photoURL, to: dstDirectory) { result in
            switch result {
            case .success():
                break
            case .failure( let error):
                XCTFail("Expected success but got error: \(error) instead")
            }
            moveExpectation.fulfill()
        }
        wait(for: [moveExpectation], timeout: 1.0)
        
        let retrieveExpectation = expectation(description: "Waiting for completion to be invoked")
        sut.retrieve(from: dstDirectory) { result in
            if case .success(let receivedURLs) = result {
                let expectedDestURL = dstDirectory.appendingPathComponent(photo.name)
                XCTAssertTrue(receivedURLs.contains(expectedDestURL))
            }
            retrieveExpectation.fulfill()
        }
        wait(for: [retrieveExpectation], timeout: 1.0)
    }
    
    func test_moveToTrash_deliverNoErrorMoveOneFile() {
        let sut = makeSUT()
        let photo = anyPhoto()
        let photoURL = testSpecificPlaceResourcesDirectoryURL().appendingPathComponent(photo.name)
        let photos = [anyPhoto(), anyPhoto(), anyPhoto(), photo, anyPhoto()]
        let url = testSpecificPlaceResourcesDirectoryURL()
        
        insert(photos, to: sut, at: url)
        
        let moveExpectation = expectation(description: "Waiting for completion to be invoked")
        sut.moveToTrash(at: photoURL) { result in
            switch result {
            case .success():
                break
            case .failure( let error):
                XCTFail("Expected success but got error: \(error) instead")
            }
            moveExpectation.fulfill()
        }
        wait(for: [moveExpectation], timeout: 1.0)
    }
    
    func test_moveToTrash_deliverNoErrorMoveOneFileByOne() {
        let sut = makeSUT()
        let photo1 = anyPhoto()
        let photo2 = anyPhoto()
        let photo1URL = testSpecificPlaceResourcesDirectoryURL().appendingPathComponent(photo1.name)
        let photo2URL = testSpecificPlaceResourcesDirectoryURL().appendingPathComponent(photo2.name)
        let photos = [photo2, anyPhoto(), anyPhoto(), photo1, anyPhoto()]
        let url = testSpecificPlaceResourcesDirectoryURL()
        
        insert(photos, to: sut, at: url)
        
        let expectation1 = expectation(description: "Waiting for completion to be invoked")
        sut.moveToTrash(at: photo1URL) { result in
            switch result {
            case .success():
                break
            case .failure( let error):
                XCTFail("Expected success but got error: \(error) instead")
            }
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 1.0)
        
        let expectation2 = expectation(description: "Waiting for completion to be invoked")
        sut.moveToTrash(at: photo2URL) { result in
            switch result {
            case .success():
                break
            case .failure( let error):
                XCTFail("Expected success but got error: \(error) instead")
            }
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 1.0)
    }
    
    func test_moveToTrash_deliverNoErrorMoveWholePlaceDirectory() {
        let sut = makeSUT()
        let photos = [anyPhoto(), anyPhoto(), anyPhoto(), anyPhoto(), anyPhoto()]
        let url = testSpecificPlaceResourcesDirectoryURL()
        
        insert(photos, to: sut, at: url)
        
        let expectation1 = expectation(description: "Waiting for completion to be invoked")
        sut.moveToTrash(at: url) { result in
            switch result {
            case .success():
                break
            case .failure( let error):
                XCTFail("Expected success but got error: \(error) instead")
            }
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 1.0)
    }
    
    func test_moveToTrash_deliverErrorUponDocumentDirectoryNotFound() {
        let sut = makeSUT(fileManager: MockFileManager())
        let photos = [anyPhoto(), anyPhoto(), anyPhoto(), anyPhoto(), anyPhoto()]
        let url = testSpecificPlaceResourcesDirectoryURL()
        
        insert(photos, to: sut, at: url)
        
        let expectation1 = expectation(description: "Waiting for completion to be invoked")
        sut.moveToTrash(at: url) { result in
            switch result {
            case .success():
                XCTFail("Expected failure but got error: \(result) instead")
            case .failure( let error):
                XCTAssertEqual(error as? FileSystemPhotoStore.PhotoStoreError, FileSystemPhotoStore.PhotoStoreError.documentDirectoryNotFound)
            }
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func insert(_ photos: [Photo], to sut: FileSystemPhotoStore, at directoryURL: URL) {
        let insertExpectation = expectation(description: "Waiting for completion to be invoked")
        sut.insert(photos, toDirectory: directoryURL) { _ in insertExpectation.fulfill() }
        wait(for: [insertExpectation], timeout: 1.0)
    }
    
    private func anyPhoto() -> Photo {
        let photoName = UUID().uuidString + ".jpg"
        let fakeJpegData = Data([1, 2, 4])
        
        return Photo(name: photoName, jpegData: fakeJpegData)
    }
    
    private func makeSUT(
        fileManager: FileManagerProtocol = FileManager.default,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> FileSystemPhotoStore {
        let sut = FileSystemPhotoStore(fileManager: fileManager)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func testSpecificPlaceResourcesDirectoryURL() -> URL {
        return documentDirectory()
            .appendingPathComponent("Memap")
            .appendingPathComponent("resources")
            .appendingPathComponent("a_place_id")
    }
    
    private func testAnyDestDirectoryURL() -> URL {
        return documentDirectory()
            .appendingPathComponent("Memap")
            .appendingPathComponent("destDirectory")
    }
    
    private func testExactResourcesTrashBasedURL() -> URL {
        return documentDirectory()
            .appendingPathComponent("Memap")
            .appendingPathComponent(".trash")
    }
    
    private func documentDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    private func emptyPhotosDirectory() {
        deletePhotos()
    }
    
    private func emptyAnyDestDirectoryURL() {
        try? FileManager.default.removeItem(at: testAnyDestDirectoryURL())
    }
    
    private func emptyTrashDirectoryURL() {
        try? FileManager.default.removeItem(at: testExactResourcesTrashBasedURL())
    }
    
    private func deletePhotos() {
        try? FileManager.default.removeItem(at: testSpecificPlaceResourcesDirectoryURL())
    }
}
