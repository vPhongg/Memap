//
//  XCTestCase+MemapStoreSpecs.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 27/02/2026.
//


import XCTest
import MemapData

extension CoreDataMemapStoreTests {
    func expect(_ sut: PlaceStore, retrievedPlacesToContain exectedPlace: LocalPlace, file: StaticString = #filePath, line: UInt = #line) async throws {
        let result = try await sut.retrieve()
        XCTAssertTrue(result.contains(exectedPlace))
    }
    
    func expect(_ sut: PlaceStore, toRetrieveTwice exectedResult: [LocalPlace], file: StaticString = #filePath, line: UInt = #line) async throws {
        try await expect(sut, toRetrieve: exectedResult, file: file, line: line)
        try await expect(sut, toRetrieve: exectedResult, file: file, line: line)
    }
    
    func expect(_ sut: PlaceStore, toRetrieve exectedPlaces: [LocalPlace], file: StaticString = #filePath, line: UInt = #line) async throws {
        let retrievedPlaces = try await sut.retrieve()
        XCTAssertEqual(retrievedPlaces, exectedPlaces, file: file, line: line)
    }
    
    func insert(_ place: LocalPlace, to sut: PlaceStore, file: StaticString = #filePath, line: UInt = #line) async throws {
        try await sut.insert(place)
    }
    
    func delete(_ place: LocalPlace, to sut: PlaceStore, file: StaticString = #filePath, line: UInt = #line) async throws {
        try await sut.delete(place)
    }
    
    func expectToRetrieveFailureTwice(from sut: PlaceStore, file: StaticString = #filePath, line: UInt = #line) async throws {
        try await expectToRetrieveFailure(from: sut)
        try await expectToRetrieveFailure(from: sut)
    }
    
    func expectToRetrieveFailure(from sut: PlaceStore, file: StaticString = #filePath, line: UInt = #line) async throws {
        do {
            let _ = try await sut.retrieve()
            expectFailure()
        } catch  {
            XCTAssertNotNil(error as NSError, file: file, line: line)
        }
    }
    
}
