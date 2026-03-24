//
//  XCTestCase+Helpers.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 27/02/2026.
//


import XCTest

extension XCTestCase {
    func expectFailure(file: StaticString = #file, line: UInt = #line) {
        XCTFail("Expected error to be thrown, but got success instead", file: file, line: line)
    }
    
    func expectSuccess(file: StaticString = #file, line: UInt = #line) {
        XCTFail("Expected success, but got error instead", file: file, line: line)
    }
}


