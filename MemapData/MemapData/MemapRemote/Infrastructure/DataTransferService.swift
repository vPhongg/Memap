//
//  DataTransferService.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 12/03/2026.
//

import Foundation

public final class DefaultDataTransferService {
    
    private let networkService: NetworkService
    
    public init(
        with networkService: NetworkService
    ) {
        self.networkService = networkService
    }
}

extension DefaultDataTransferService: DataTransferService {
    
    public func request(
        completion: @escaping CompletionHandler
    ) -> NetworkCancellable? {

        networkService.request { result in
            switch result {
            case .success(let data):
                do {
                    let places = try JSONDecoder().decode([PlaceInfoResponseDTO].self, from: data)
                    completion(.success(places))
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
