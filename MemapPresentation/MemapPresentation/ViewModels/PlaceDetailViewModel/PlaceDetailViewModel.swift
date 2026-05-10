//
//  PlaceDetailViewModel.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 06/03/2026.
//

import Foundation
import MemapData

public struct ImagePresentationModel {
    public let name: String
    public let jpegData: Data
    
    public init(name: String, jpegData: Data) {
        self.name = name
        self.jpegData = jpegData
    }
}

@Observable
public class PlaceDetailViewModel {
    
    let placeSaver: PlaceSavable
    let placeDeletor: PlaceDeletable
    
    let photoSaver: PhotoSavable
    
    public var model: PlacePresentationModel = PlacePresentationModel.defaultObject()
    public var removedPlace: PlacePresentationModel?
    
    public static var addPlaceText: String {
        return Constant.addPlace.localized
    }
    
    public static var removePlaceText: String {
        return Constant.removePlace.localized
    }
    
    public init(
        saver: PlaceSavable,
        deletor: PlaceDeletable,
        photoSaver: PhotoSavable
    ) {
        self.placeSaver = saver
        self.placeDeletor = deletor
        self.photoSaver = photoSaver
    }
    
    public func didTapAddPlaceButton() {
        Task {
            try await save(model.toPresentationModel())
            model.isSaved = true
        }
    }
    
    public func didTapRemovePlaceButton() {
        Task {
            try await placeDeletor.delete(model.toPresentationModel())
            removedPlace = model
        }
    }
    
    public func save(_ images: [ImagePresentationModel], placeID: String) -> Void {
        Task {
            try await photoSaver.save(images.toPhotos(), placeID: placeID)
        }
        
    }
    
    private func save(_ place: Place) async throws -> Void {
        try await placeSaver.save(place)
    }
    
}

extension Array where Element == ImagePresentationModel {
    func toPhotos() -> [Photo] {
        self.map { Photo(name: $0.name, jpegData: $0.jpegData) }
    }
}
