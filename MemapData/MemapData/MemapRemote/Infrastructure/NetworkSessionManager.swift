//
//  NetworkSessionManager.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 12/03/2026.
//

import Foundation

public protocol NetworkSessionManager {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    func request(
        _ request: URLRequest,
        completion: @escaping CompletionHandler
    ) -> NetworkCancellable
}

public final class DefaultNetworkSessionManager: NetworkSessionManager {
    
    public init() {}
    
    public func request(
        _ request: URLRequest,
        completion: @escaping CompletionHandler
    ) -> NetworkCancellable {
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
        return task
    }
}
