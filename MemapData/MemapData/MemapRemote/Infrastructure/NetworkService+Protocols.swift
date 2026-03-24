//
//  NetworkCancellable.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 13/03/2026.
//

import Foundation

public protocol NetworkCancellable {
    func cancel()
}

extension URLSessionTask: NetworkCancellable { }


/// Logger, Network Config for networking and error can be implement here.
public protocol NetworkService {
    typealias CompletionHandler = (Result<Data, Error>) -> Void
    
    func request(completion: @escaping CompletionHandler) -> NetworkCancellable?
}
