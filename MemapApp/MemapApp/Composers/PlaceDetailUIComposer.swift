//
//  MapUIComposer.swift
//  MemapApp
//
//  Created by Vu Dinh Phong on 09/04/2026.
//

import SwiftUI
import Foundation
import MemapPresentation
import MemapData
import MemapDomain
import MemapUI

final class PlaceDetailUIComposer {
    private init() {}
    
    static func composedWith(saver: PlaceSaver, deletor: PlaceDeletor) -> UIHostingController<MapView> {
        let mapViewModel = DefaultMapViewModel(memapLoader: loader)
        let anyMapViewModel = AnyMapViewModel(mapViewModel)
        let mapView = MapView(isPresentingPlaceInfoDetailView: false, viewModel: anyMapViewModel, onSelectItem: { _ in })
        return UIHostingController(rootView: mapView)
    }
}
