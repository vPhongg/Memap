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
    
    static func composed(loader: PlaceLoadable, cache: PlaceSavable, deletor: PlaceDeletable) -> UIHostingController<MainView> {
        let mapViewModel = DefaultMapViewModel(memapLoader: loader)
        let anyMapViewModel = AnyMapViewModel(mapViewModel)
        
        let placeDetailViewModel = PlaceDetailViewModel(saver: cache, deletor: deletor, photoSaver: makePhotoPersistentManager())
        let placesListViewModel = DefaultPlacesListViewModel(loader: loader)
        let placesListViewModelWrapper = DefaultPlacesListViewModelWrapper(viewModel: placesListViewModel)
        
        let mainView = MainView(
            mapViewModel: anyMapViewModel,
            placeDetailViewModel: placeDetailViewModel,
            placesListViewModel: placesListViewModelWrapper
        )
        return UIHostingController(rootView: mainView)
    }
    
    private static func makePhotoPersistentManager() -> PhotoPersistentManager {
        let photoStore = FileSystemPhotoStore()
        return PhotoPersistentManager(store: photoStore)
    }
}
