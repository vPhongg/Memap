//
//  File.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 26/02/2026.
//


import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        // addTeardownBlock is being invoked after each test
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should be deallocated, Potential memory leaks.", file: file, line: line)
        }
    }
}
