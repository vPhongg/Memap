//
//  AnyMapViewModel.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 16/03/2026.
//

import Foundation
import MemapData

/// A type eraser for `DefaultMapViewModel` since `MapViewModel` is protocol can not work with @Bindable for `MapView`
@Observable
final public class AnyMapViewModel: MapViewModel {
    
    private let _getIsLoading: () -> Bool
    private let _getPlaces: () -> [Place]
    private let _performLoad: () async throws -> Void
    
    public var isLoading: Bool {
        _getIsLoading()
    }
    
    public var places: [Place] {
        _getPlaces()
    }
    
    public func load() async throws {
        try await _performLoad()
    }
    
    public init<ViewModel: MapViewModel>(_ viewModel: ViewModel) {
        _getIsLoading = { viewModel.isLoading }
        _getPlaces = { viewModel.places }
        _performLoad = { try await  viewModel.load() }
    }
    
}
