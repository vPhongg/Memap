//
//  LocalMemapLoaderDeletePlaceUseCaseTests.swift
//  MemapDataTests
//
//  Created by Vu Dinh Phong on 10/03/2026.
//

import XCTest
import MemapData

final class DeleteOnePlaceFromPersistentStorageUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_delete_succeededDeletion() async throws {
        let place = uniquePlace()
        let fixedCurrentDate = Date()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        try await sut.delete(place)
        
        XCTAssertEqual(store.receivedMessages, [.delete(place.toLocal())])
    }
    
    func test_delete_failsOnDeletionError() async throws {
        let place = uniquePlace()
        let (sut, store) = makeSUT()
        store.deletionResult = .failure(anyNSError())
        
        do {
            try await sut.delete(place)
            expectFailure()
        } catch {
            XCTAssertEqual(error as NSError, anyNSError())
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalMemapLoader, store: MemapStoreSpy) {
        let store = MemapStoreSpy()
        let sut = LocalMemapLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }

}
