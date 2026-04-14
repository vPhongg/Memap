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
import MemapUI

final class MainViewComposer {
    private init() {}
    
    static func composed(loader: PlaceLoader, cache: PlaceSaver, deletor: PlaceDeletor) -> UIHostingController<MainView> {
        let mapViewModel = DefaultMapViewModel(memapLoader: loader)
        let anyMapViewModel = AnyMapViewModel(mapViewModel)
        
        let placeDetailViewModel = PlaceDetailViewModel(saver: cache, deletor: deletor)
        let placesListViewModel = DefaultPlacesListViewModel(loader: loader)
        let placesListViewModelWrapper = DefaultPlacesListViewModelWrapper(viewModel: placesListViewModel)
        
        let mainView = MainView(
            mapViewModel: anyMapViewModel,
            placeDetailViewModel: placeDetailViewModel,
            placesListViewModel: placesListViewModelWrapper
        )
        return UIHostingController(rootView: mainView)
    }
}
