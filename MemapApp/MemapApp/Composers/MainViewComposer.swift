//
//  MapViewComposer.swift
//  MemapApp
//
//  Created by Vu Dinh Phong on 25/02/2026.
//

import Foundation
import SwiftUI
import MemapPresentation
import MemapData
import MemapDomain
import MemapUI

final class MainViewComposer {
    private init() {}
    
    static func composed(loader: MemapLoader, cache: MemapCache, deletor: MemapDelete) -> UIHostingController<MainView> {
        let mapViewModel = DefaultMapViewModel(memapLoader: loader)
        let anyMapViewModel = AnyMapViewModel(mapViewModel)
        
        let placeInfoDetailViewModel = PlaceInfoDetailViewModel(cache: cache, deletor: deletor)
        
        let networkService = DefaultNetworkService(sessionManager: DefaultNetworkSessionManager())
        let placesListDataTransferService = DefaultDataTransferService(with: networkService)
        let placesListRepository = DefaultPlacesRepository(dataTransferService: placesListDataTransferService)
        let loadPlacesUseCase = DefaultLoadPlacesUseCase(placesRepository: placesListRepository)
        let placesListViewModel = DefaultPlacesListViewModel(loadPlacesUseCase: loadPlacesUseCase)
        let placesListViewModelWrapper = DefaultPlacesListViewModelWrapper(viewModel: placesListViewModel)
        
        let mainView = MainView(
            mapViewModel: anyMapViewModel,
            placeInfoDetailViewModel: placeInfoDetailViewModel,
            placesListViewModel: placesListViewModelWrapper
        )
        return UIHostingController(rootView: mainView)
    }
}
