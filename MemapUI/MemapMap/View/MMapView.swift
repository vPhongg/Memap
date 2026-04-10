//
//  MMapView.swift
//  MemapMap
//
//  Created by Vu Dinh Phong on 09/04/2026.
//

import SwiftUI

public struct MMapView: UIViewControllerRepresentable {
    
    private let items: [MMapItem]
    private let didSelectMapKitPOI: (MMapItem) -> Void
    
    public init(
        items: [MMapItem],
        didSelectMapKitPOI: @escaping (MMapItem) -> Void
    ) {
        self.items = items.addMKMapItem()
        self.didSelectMapKitPOI = didSelectMapKitPOI
    }
    
    public func makeUIViewController(context: Context) -> MapViewController {
        return MapViewController(
            items: items.toPlaceAnnotations(),
            didSelectMapKitPOI: { item in
                didSelectMapKitPOI(item)
            })
    }
    
    public func updateUIViewController(_ mapController: MapViewController, context: Context) {
        mapController.updateItems(items.toPlaceAnnotations())
    }
}
