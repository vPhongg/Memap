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
                places.value = try await loader.load().toModels()
            } catch {
                self.error.value = error.localizedDescription
            }
            self.isLoading.value = false
        }
    }
}
