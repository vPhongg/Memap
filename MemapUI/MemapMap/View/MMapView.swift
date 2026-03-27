//
//  MMapView.swift
//  MemapMap
//
//  Created by Vu Dinh Phong on 23/03/2026.
//

import UIKit
import SwiftUI
import MapKit

public struct MMapView: UIViewRepresentable {
    
    private var mapItems: [MMapItem]
    var onSelectItem: (MMapItem) -> Void
    @Binding private var isPresentingPlaceInfoDetailView: Bool
    
    public init(
        mapItems: [MMapItem],
        isPresentingPlaceInfoDetailView: Binding<Bool>,
        onSelectItem: @escaping (MMapItem) -> Void
        
    ) {
        self.mapItems = mapItems
        self._isPresentingPlaceInfoDetailView = isPresentingPlaceInfoDetailView
        self.onSelectItem = onSelectItem
    }
    
    public func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        context.coordinator.mapView = map
        map.delegate = context.coordinator
        map.showsUserLocation = true
        map.pointOfInterestFilter = .includingAll
        map.selectableMapFeatures = [.physicalFeatures, .pointsOfInterest, .territories]
        map.setUserTrackingMode(.follow, animated: true)
        registerAnnotationViewClasses(for: map)
        return map
    }
    
    public func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(mapItems.toMMapAnnotations())
    }
    
    public func makeCoordinator() -> MMapCoordinator {
        let coordinator = MMapCoordinator()
        let adapter = MMapViewCoordinatorAdapter()
        adapter.onSelectMapKitPOI = { annotation in
            isPresentingPlaceInfoDetailView = true
        }
        adapter.deselectAnnotation = { _ in
            isPresentingPlaceInfoDetailView = false
        }
        coordinator.delegate = adapter
        return coordinator
    }
    
    private func registerAnnotationViewClasses(for mapView: MKMapView) {
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(CustomAnnotationView.self))
    }
    
}

final class MMapViewCoordinatorAdapter: MMapCoordinatorDelegate {
    
    var onSelectCustomAnnotation: ((MKAnnotation) -> Void)?
    var onSelectMapKitPOI: ((MKAnnotation) -> Void)?
    var deselectAnnotation: ((MKAnnotation) -> Void)?
    
    func didSelectCustomAnnotation(_ annotation: any MKAnnotation) {
        onSelectCustomAnnotation?(annotation)
    }
    
    func didSelectMapKitPOI(_ annotation: any MKAnnotation) {
        onSelectMapKitPOI?(annotation)
    }
    
    func didDeselectAnnotation(_ annotation: any MKAnnotation) {
        deselectAnnotation?(annotation)
    }
    
}
