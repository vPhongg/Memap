//
//  URLSessionHTTPClient.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 16/04/2026.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    struct HTTPClientTaskWrapped: HTTPClientTask {
        let wrapped: URLSessionTask
        
        func cancel() {
            wrapped.cancel()
        }
    }
    
    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error as? NSError {
                completion(.failure(error))
            } else {
                if let data = data,
                   let response = response as? HTTPURLResponse {
                    completion(.success((data, response)))
                } else {
                    completion(.failure(UnexpectedValuesRepresentation()))
                }
            }
        }
        task.resume()
        return HTTPClientTaskWrapped(wrapped: task)
    }
    
    public func get(from url: URL) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await session.data(from: url)
        
        if let response = response as? HTTPURLResponse {
         return (data, response)
     } else {
         throw UnexpectedValuesRepresentation()
     }
        
    }
}
