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
    
    public var model: PlacePresentationModel = PlacePresentationModel.defaultObject()
    
    public var removedPlace: PlacePresentationModel?
    
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
            try await save(model.toPresentationModel())
            model.isSaved = true
        }
    }
    
    public func didTapRemovePlaceButton() {
        Task {
            try await deletor.delete(model.toPresentationModel())
            removedPlace = model
        }
    }
    
    private func save(_ place: Place) async throws -> Void {
        try await saver.save(place)
    }
    
}
