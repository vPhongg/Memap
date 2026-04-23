//
//  MMapView.swift
//  MemapMap
//
//  Created by Vu Dinh Phong on 09/04/2026.
//

import SwiftUI

public struct MMapView: UIViewControllerRepresentable {
    
    // Incoming data
    private let selectedPlaceID: String?
    private let isPresentingPlaceDetailView: Bool
    private let items: [MMapItem]
    
    // Outgoing data
    private let didSelectMapKitPOI: MapItemSelectionHandler
    private let didDeselectMapKitPOI: MapItemDeselectionHandler
    
    public init(
        items: [MMapItem],
        selectedPlaceID: String?,
        isPresentingPlaceDetailView: Bool,
        didSelectMapKitPOI: @escaping MapItemSelectionHandler,
        didDeselectMapKitPOI: @escaping MapItemDeselectionHandler
    ) {
        self.items = items
        self.selectedPlaceID = selectedPlaceID
        self.isPresentingPlaceDetailView = isPresentingPlaceDetailView
        self.didSelectMapKitPOI = didSelectMapKitPOI
        self.didDeselectMapKitPOI = didDeselectMapKitPOI
    }
    
    public func makeUIViewController(context: Context) -> MapViewController {
        return MapViewController(
            items: items.toPlaceAnnotations(),
            didSelectMapItem: { didSelectMapKitPOI($0) },
            didDeselectMapKitPOI: didDeselectMapKitPOI)
    }
    
    public func updateUIViewController(_ mapController: MapViewController, context: Context) {
        mapController.updateItems(items.toPlaceAnnotations())
        
        if let selectedPlaceID {
            mapController.selectPlace(id: selectedPlaceID)
        }
        
        
        if !isPresentingPlaceDetailView {
            mapController.deselectSelectedPOI()
        }
    }
}
