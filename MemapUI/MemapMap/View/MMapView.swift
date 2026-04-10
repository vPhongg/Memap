//
//  MMapView.swift
//  MemapMap
//
//  Created by Vu Dinh Phong on 09/04/2026.
//

import SwiftUI

public struct MMapView: UIViewControllerRepresentable {
    
    private let items: [MMapItem]
    private let onSelectItem: (MMapItem) -> Void
    
    public init(
        items: [MMapItem],
        onSelectItem: @escaping (MMapItem) -> Void
    ) {
        self.items = items.addMKMapItem()
        self.onSelectItem = onSelectItem
    }
    
    public func makeUIViewController(context: Context) -> MapViewController {
        return MapViewController(items: items.toPlaceAnnotations(), onSelectItem: { _ in
            print("onSelectItem")
        })
    }
    
    public func updateUIViewController(_ mapController: MapViewController, context: Context) {
        mapController.updateItems(items.toPlaceAnnotations())
    }
}
