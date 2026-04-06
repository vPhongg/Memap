//
//  LoadPlacesFromPersistentStorageUseCaseTests.swift
//  MemapDataTests
//
//  Created by Vu Dinh Phong on 26/02/2026.
//

import XCTest
import MemapData

final class LoadPlacesFromPersistentStorageUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestPlacesRetrieval() async throws {
        let (sut, store) = makeSUT()
        
        let _ = try await sut.load()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() async throws {
        let (sut, store) = makeSUT()
        store.retrieveResult = .failure(anyNSError())
        
        do {
            let _ = try await sut.load()
            expectFailure()
        } catch {
            XCTAssertEqual(error as NSError, anyNSError())
        }
    }
    
    func test_load_deliversNoPlacesOnEmptyData() async throws {
        let (sut, store) = makeSUT()
        store.retrieveResult = .success([])
        
        let result = try await sut.load()
        
        XCTAssertEqual(result, [])
    }
    
    func test_load_hasNoSideEffectsOnRetrievalError() async throws {
        let (sut, store) = makeSUT()
        store.retrieveResult = .failure(anyNSError())
        
        do {
            let _ = try await sut.load()
            expectFailure()
        } catch {
            XCTAssertEqual(error as NSError, anyNSError())
            XCTAssertEqual(store.receivedMessages, [.retrieve])
        }
    }
    
    func test_load_hasNoSideEffectsOnEmptyData() async throws {
        let (sut, store) = makeSUT()
        store.retrieveResult = .success([])
        
        let result = try await sut.load()
        
        XCTAssertEqual(result, [])
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    
    // MARK: Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalPlaceLoader, store: MemapStoreSpy) {
        let store = MemapStoreSpy()
        let sut = LocalPlaceLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
}
