//
//  PlacesListViewModel.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 11/03/2026.
//

import Foundation
import MemapDomain

public final class DefaultPlacesListViewModel: PlacesListViewModel {
    
    private let loadPlacesUseCase: LoadPlacesUseCase
    
    // MARK: - OUTPUT
    public let isLoading: Observable<Bool> = Observable(false)
    public var places: Observable<[PlaceInfoViewModel]> = Observable([])
    public var error: Observable<String> = Observable(.empty)
    
    public init(
        loadPlacesUseCase: LoadPlacesUseCase
    ) {
        self.loadPlacesUseCase = loadPlacesUseCase
    }
    
    public func load() {
        self.isLoading.value = true
        
        loadPlacesUseCase.execute { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let places):
                self.places.value = places.toModels()
                
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
            self.isLoading.value = false
        }
    }
}

extension Array where Element == PlaceInfoDomain {
    func toModels() -> [PlaceInfoViewModel] {
        return compactMap { item in
            if let lat = item.latitude, let long = item.longitude {
                return PlaceInfoViewModel(
                    id: item.id,
                    name: item.name,
                    latitude: lat,
                    longitude: long,
                    savedTimestamp: item.savedTimestamp,
                    imagesPath: item.imagesPath,
                    videosPath: item.videosPath,
                    note: item.note,
                    isAdded: item.isAdded
                )
            } else {
                return nil
            }
        }
    }
}
