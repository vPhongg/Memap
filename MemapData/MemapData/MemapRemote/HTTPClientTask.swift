//
//  HTTPClientTask.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 16/04/2026.
//

import Foundation

public protocol HTTPClientTask {
    func cancel()
}

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    /// The completion handler can be invoked in any threads
    /// Clients are responsible to dispatch to appropriate threads, if need
    /// - Parameters:
    ///   - url: URL
    ///   - completion: Swift.Result<(Data, HTTPURLResponse), Error>
    @discardableResult
    func get(from url: URL, completion: @escaping (Result) -> Void) -> HTTPClientTask
}
