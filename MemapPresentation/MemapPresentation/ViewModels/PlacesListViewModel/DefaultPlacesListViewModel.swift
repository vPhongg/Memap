//
//  PlacesListViewModel.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 11/03/2026.
//

import Foundation
import MemapData

public final class DefaultPlacesListViewModel: PlacesListViewModel {
    
    private let loader: PlaceLoader
    
    // MARK: - OUTPUT
    public let isLoading: Observable<Bool> = Observable(false)
    public var places: Observable<[PlacePresentationModel]> = Observable([])
    public var placeGroups: Observable<[PlaceGroup]> = Observable([])
    public var error: Observable<String> = Observable(.empty)
    
    public init(
        loader: PlaceLoader
    ) {
        self.loader = loader
    }
    
    public func load() {
        self.isLoading.value = true
        
        Task {
            do {
                let places = try await loader.load()
                placeGroups.value = mapToPlaceGroups(from: places)
                
            } catch {
                self.error.value = error.localizedDescription
            }
            self.isLoading.value = false
        }
    }
    
    private func mapToPlaceGroups(from places: [Place]) -> [PlaceGroup] {
        return [
            PlaceGroup(name: "Eating", places: [
                PlacePresentationModel.defaultObject(),
                PlacePresentationModel.defaultObject(),
            ]),
            PlaceGroup(name: "Store", places: [
                PlacePresentationModel.defaultObject(),
                PlacePresentationModel.defaultObject(),
            ]),
            PlaceGroup(name: "Tourism", places: [
                PlacePresentationModel.defaultObject(),
                PlacePresentationModel.defaultObject(),
            ]),
        ]
    }
}
