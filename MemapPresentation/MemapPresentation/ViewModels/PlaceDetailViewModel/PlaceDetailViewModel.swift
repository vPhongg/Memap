//
//  PlaceDetailViewModel.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 06/03/2026.
//

import Foundation
import MemapData

@Observable
public class PlaceDetailViewModel {
    
    let saver: PlaceSaver
    let deletor: PlaceDeletor
    
    public var model: PlaceInfoViewModel = PlaceInfoViewModel.defaultObject()
    
    public var removedPlace: PlaceInfoViewModel?
    
    public static var addPlaceText: String {
        return Constant.addPlace.localized
    }
    
    public static var removePlaceText: String {
        return Constant.removePlace.localized
    }
    
    public init(saver: PlaceSaver, deletor: PlaceDeletor) {
        self.saver = saver
        self.deletor = deletor
    }
    
    public func didTapAddPlaceButton() {
        Task {
            try await save(model.toModel())
            model.isSaved = true
        }
    }
    
    public func didTapRemovePlaceButton() {
        Task {
            try await deletor.delete(model.toModel())
            removedPlace = model
        }
    }
    
    private func save(_ place: PlaceInfo) async throws -> Void {
        try await saver.save(place)
    }
    
}
