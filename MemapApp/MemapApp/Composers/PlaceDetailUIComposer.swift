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
    
    static func composedWith(saver: PlaceSaver, deletor: PlaceDeletor) -> UIHostingController<PlaceDetailView> {
        let viewModel = PlaceDetailViewModel(saver: saver, deletor: deletor)
        let placeDetailView = PlaceDetailView(viewModel: viewModel)
        return UIHostingController(rootView: placeDetailView)
    }
}
