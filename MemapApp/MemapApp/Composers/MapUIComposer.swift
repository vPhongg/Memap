//
//  MapUIComposer.swift
//  MemapApp
//
//  Created by Vu Dinh Phong on 09/04/2026.
//

import Foundation
import MemapPresentation
import MemapData
import MemapDomain
import MemapUI
import MemapMap

final class MapUIComposer {
    private init() {}
    
    static func composedWith(loader: PlaceLoader, saver: PlaceSaver, deletor: PlaceDeletor) -> MapViewController {
        let bundle = Bundle(for: MapViewController.self)
        return MapViewController(nibName: "MapViewController", bundle: bundle)
    }
}
