//
//  NetworkError.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 12/03/2026.
//

import Foundation

public final class DefaultNetworkService {
    
    private let sessionManager: NetworkSessionManager
    
    public init(
        sessionManager: NetworkSessionManager,
    ) {
        self.sessionManager = sessionManager
    }
    
    private func request(
        request: URLRequest,
        completion: @escaping CompletionHandler
    ) -> NetworkCancellable {
        
        let sessionDataTask = sessionManager.request(request) { data, response, requestError in
            
            if let requestError = requestError {
                completion(.failure(requestError))
            } else {
                completion(.success(data!))
            }
        }
    
        return sessionDataTask
    }
}

extension DefaultNetworkService: NetworkService {
    
    public func request(
        completion: @escaping CompletionHandler
    ) -> NetworkCancellable? {
        let url = URL(string: "http://localhost:3000/places")!
        let urlRequest = URLRequest(url: url)
        return request(request: urlRequest, completion: completion)
    }
    
}
