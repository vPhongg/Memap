//
//  CoreDataMemapStoreTests.swift
//  MemapDataTests
//
//  Created by Vu Dinh Phong on 27/02/2026.
//

import XCTest
import MemapData
import CoreData

final class CoreDataMemapStoreTests: XCTestCase {
    
    // MARK: Test Retrievals
    
    func test_retrieve_deliversEmptyOnEmptyCache() async throws {
        let sut = makeSUT()
        
        try await expect(sut, toRetrieve: [])
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() async throws {
        let sut = makeSUT()
        
        try await expect(sut, toRetrieveTwice: [])
    }
    
    func test_retrieve_deliversValuesOnNonEmptyCache() async throws {
        let sut = makeSUT()
        let insertedPlace = uniquePlace().toLocal()
        
        try await insert(insertedPlace, to: sut)
        
        do {
            let retrievedPlaces = try await sut.retrieve()
            
            XCTAssertEqual(retrievedPlaces.count, 1)
            XCTAssertTrue(retrievedPlaces.contains(insertedPlace))
        } catch {
            XCTFail("Expect to retrieve \(insertedPlace), but got \(error) instead")
        }
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() async throws {
        let sut = makeSUT()
        let place = uniquePlace().toLocal()
        
        try await insert(place, to: sut)
        
        try await expect(sut, toRetrieveTwice: ([place]))
    }
    
    func test_retrieve_deliversFailureOnRetrievalError() async throws {
        let stub = NSManagedObjectContext.alwaysFailingFetchStub()
        stub.startIntercepting()
        let sut = makeSUT()
        
        try await expectToRetrieveFailure(from: sut)
    }
    
    func test_retrieve_hasNoSideEffectsOnFailure() async throws {
        let stub = NSManagedObjectContext.alwaysFailingFetchStub()
        stub.startIntercepting()
        
        let sut = makeSUT()
        
        try await expectToRetrieveFailureTwice(from: sut)
    }
    
    
    // MARK: Test Inserts
    
    func test_insert_deliversNoErrorOnEmptyCache() async throws {
        let sut = makeSUT()
        
        do {
            try await insert(uniquePlace().toLocal(), to: sut)
        } catch {
            expectSuccess()
        }
    }
    
    func test_insert_deliversNoErrorOnNonEmptyCache() async throws {
        let sut = makeSUT()
        
        try await insert(uniquePlace().toLocal(), to: sut)
        
        do {
            try await insert(uniquePlace().toLocal(), to: sut)
        } catch {
            expectSuccess()
        }
    }
    
    func test_insert_deliversCorrectPlacesWithMultipleInserted() async throws {
        let sut = makeSUT()
        let places = uniquePlaces().locals
        
        for place in places {
            try await insert(place, to: sut)
        }
        
        let retrievedPlaces = try await sut.retrieve()
        
        XCTAssertEqual(retrievedPlaces, places)
    }
    
    func test_insert_deliversErrorOnInsertionError() async throws {
        let stub = NSManagedObjectContext.alwaysFailingSaveStub()
        stub.startIntercepting()
        
        let sut = makeSUT()
        
        do {
            try await insert(uniquePlace().toLocal(), to: sut)
            expectFailure()
        } catch {
            XCTAssertNotNil(error as NSError)
        }
    }
    
    func test_insert_hasNoSideEffectsOnInsertionError() async throws {
        let stub = NSManagedObjectContext.alwaysFailingSaveStub()
        stub.startIntercepting()
        
        let sut = makeSUT()
        
        do {
            try await insert(uniquePlace().toLocal(), to: sut)
            expectFailure()
        } catch {
            XCTAssertNotNil(error as NSError)
            try await expect(sut, toRetrieve: ([]))
        }
        
    }
    
    // MARK: Test Deletes
    
    func test_delete_deliversNoErrorOnEmptyCache() async throws {
        let sut = makeSUT()
        
        do {
            try await delete(uniquePlace().toLocal(), to: sut)
        } catch {
            expectSuccess()
        }
    }
    
    func test_delete_successfulDeletionWhenDataOnlyContainOneValue() async throws {
        let sut = makeSUT()
        let place = uniquePlace().toLocal()
        do {
            try await insert(place, to: sut)
            try await delete(place, to: sut)
            try await expect(sut, toRetrieve: [])
        } catch {
            expectSuccess()
        }
    }
    
    func test_delete_sucessDeletePlaceWithMultipleSavedPlaces() async throws {
        let sut = makeSUT()
        let place1 = uniquePlace().toLocal()
        let place2 = uniquePlace().toLocal()
        let place3 = uniquePlace().toLocal()
        let place4 = uniquePlace().toLocal()
        let place5 = uniquePlace().toLocal()
        
        try await insert(place1, to: sut)
        try await insert(place2, to: sut)
        try await insert(place3, to: sut)
        try await insert(place4, to: sut)
        try await insert(place5, to: sut)
        
        try await delete(place4, to: sut)
        
        try await expect(sut, toRetrieve: [place1, place2, place3 , place5])
    }
    
    func test_delete_sucessDeleteMultiplePlacesWithMultipleSavedPlaces() async throws {
        let sut = makeSUT()
        let place1 = uniquePlace().toLocal()
        let place2 = uniquePlace().toLocal()
        let place3 = uniquePlace().toLocal()
        let place4 = uniquePlace().toLocal()
        let place5 = uniquePlace().toLocal()
        
        try await insert(place1, to: sut)
        try await insert(place2, to: sut)
        try await insert(place3, to: sut)
        try await insert(place4, to: sut)
        try await insert(place5, to: sut)
        
        try await delete(place1, to: sut)
        try await delete(place3, to: sut)
        try await delete(place5, to: sut)
        
        try await expect(sut, toRetrieve: [place2, place4])
    }
    
    
    
    // - MARK: Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> MemapStore {
        let sut = try! CoreDataMemapStore(storeURL: inMemoryStoreURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private var inMemoryStoreURL: URL {
        URL(fileURLWithPath: "/dev/null")
            .appendingPathComponent("\(type(of: self)).store")
    }
    
}
