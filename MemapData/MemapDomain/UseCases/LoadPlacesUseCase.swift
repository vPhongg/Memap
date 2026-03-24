//
//  LoadPlacesUseCase.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 11/03/2026.
//

public final class DefaultLoadPlacesUseCase: LoadPlacesUseCase {
    
    private let placesRepository: PlacesRepository
    
    public init(
        placesRepository: PlacesRepository,
    ) {
        self.placesRepository = placesRepository
    }
    
    public func execute(
        completion: @escaping (Result<[PlaceInfoDomain], Error>) -> Void
    ) {
        // Do any application logic here before pass `to ViewModel`
        return placesRepository.fetchPlacesList(completion: completion)
    }
}
