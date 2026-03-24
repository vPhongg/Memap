//
//  DefaultPlacesRepository.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 12/03/2026.
//

import Foundation
import MemapDomain

public final class DefaultPlacesRepository {
    
    private let dataTransferService: DataTransferService
    
    public init(
        dataTransferService: DataTransferService,
    ) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultPlacesRepository: PlacesRepository {
    
    public func fetchPlacesList(
        completion: @escaping (Result<[PlaceInfoDomain], Error>) -> Void
    ) {
        
        dataTransferService.request { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toModels()))
            case .failure(let error):
                completion(.failure(error))
//                completion(.success(self.loadPlacesFromJsonFile().toModels()))
            }
        }
    }
    
    func loadPlacesFromJsonFile() -> [PlaceInfoResponseDTO] {
        guard let bundle = Bundle(identifier: "com.vphong.MemapData"),
              let url = bundle.url(forResource: "places", withExtension: "json") else {
            fatalError("places.json not found")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let places = try JSONDecoder().decode([PlaceInfoResponseDTO].self, from: data)
            return places
        } catch {
            print("Error loading JSON:", error)
            return []
        }
    }
    
}
