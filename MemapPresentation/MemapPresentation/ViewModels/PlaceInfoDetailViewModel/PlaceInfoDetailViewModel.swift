//
//  PlaceInfoDetailViewModel.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 06/03/2026.
//

import Foundation
import MemapData

@Observable
public class PlaceInfoDetailViewModel {
    
    let cache: PlaceSaver
    let deletor: PlaceDeletor
    
    public var model: PlaceInfoViewModel = PlaceInfoViewModel(id: UUID(), name: .empty, latitude: 0, longitude: 0, createdTimestamp: Date(), imagePath: nil, isAdded: false)
    
    public static var addPlaceText: String {
        return Constant.addPlace.localized
    }
    
    public static var removePlaceText: String {
        return Constant.removePlace.localized
    }
    
    public init(cache: PlaceSaver, deletor: PlaceDeletor) {
        self.cache = cache
        self.deletor = deletor
    }
    
    public func didTapAddPlaceButton() {
        Task {
            try await save(model.toModel())
            model.isAdded = true
        }
    }
    
    public func didTapRemovePlaceButton() {
        Task {
            try await deletor.delete(model.toModel())
        }
    }
    
    private func save(_ place: PlaceInfo) async throws -> Void {
        try await cache.save(place)
    }
    
}
