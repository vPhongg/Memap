//
//  PlaceDetailViewModel.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 06/03/2026.
//

import Foundation
import MemapData
import UIKit

@Observable
public class PlaceDetailViewModel {
    
    let placeSaver: PlaceSavable
    let placeDeletor: PlaceDeletable
    
    let photoSaver: PhotoSavable
    let photoLoader: PhotoLoadable
    
    public var model: PlacePresentationModel = PlacePresentationModel.defaultObject()
    public var removedPlace: PlacePresentationModel?
    
    // MARK: - States for Photos
    public var imageState: ImageState = .empty
    
    public static var addPlaceText: String {
        return Constant.addPlace.localized
    }
    
    public static var removePlaceText: String {
        return Constant.removePlace.localized
    }
    
    public init(
        saver: PlaceSavable,
        deletor: PlaceDeletable,
        photoSaver: PhotoSavable,
        photoLoader: PhotoLoadable
    ) {
        self.placeSaver = saver
        self.placeDeletor = deletor
        self.photoSaver = photoSaver
        self.photoLoader = photoLoader
    }
    
    // MARK: - Place Methods
    
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
    
    
    // // MARK: - Image Methods
    
    public func save(_ images: [ImagePresentationModel], placeID: String) -> Void {
        Task {
            try await photoSaver.save(images.toPhotos(), placeID: placeID)
        }
    }
    
    public func loadImages() {
        self.imageState = .loading
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            
            self.photoLoader.loadImages(for: model.id) { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let urls):
                    self.imageState = .success(urls.compactMap { UIImage(contentsOfFile: $0.path()) })
                    
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
    
    public func updateImageState(with images: [ImagePresentationModel]) {
        DispatchQueue.global().async {
            let images = images.compactMap { UIImage(data: $0.jpegData) }
            self.imageState = .success(images)
        }
    }
    
    // MARK: - Private Methods
    
    private func save(_ place: Place) async throws -> Void {
        try await placeSaver.save(place)
    }
    
}
