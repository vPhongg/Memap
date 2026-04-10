//
//  MemapMap.swift
//  MemapMap
//
//  Created by Vu Dinh Phong on 14/02/2026.
//

import SwiftUI
import MapKit


/// A view that conforms to SwiftUI View
public struct MMap: View {
    
    @State private var selectedItem: MapSelection<MMapItem>?
    @State private var selectedID: UUID?
    @State private var userLocation: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    //    @State private var userLocation: MapCameraPosition = .automatic
    
    @Binding var isPresentingPlaceInfoDetailView: Bool
    
    private var items: [MMapItem]
    
    var onSelectItem: MapItemSelectionHandler
    
    public init(
        items: [MMapItem],
        isPresentingPlaceInfoDetailView: Binding<Bool>,
        onSelectItem: @escaping MapItemSelectionHandler
    ) {
        self.items = items.addMKMapItem()
        self._isPresentingPlaceInfoDetailView = isPresentingPlaceInfoDetailView
        self.onSelectItem = onSelectItem
    }
    
    private let locationManager = CLLocationManager()
    
    public var body: some View {
        Map(position: $userLocation, selection: $selectedItem) {
            UserAnnotation(anchor: .center) {
                CustomUserLocationView()
            }
            ForEach(items, id: \.id) { item in
                if let mkMapItem = item.mapItem {
                    Annotation(item: mkMapItem, anchor: .bottom, content: {
                        PlaceMarkerView(
                            size: 29,
                            isActive: item.id == selectedID && isPresentingPlaceInfoDetailView
                        )
                        .contentShape(Rectangle())
                    })
                    .tag(MapSelection(item))
                }
            }
        }
        .mapFeatureSelectionDisabled { feature in
            feature.kind != MapFeature.FeatureKind.pointOfInterest
        }
        .contentMargins(20)
        .onAppear {
            locationManager.requestWhenInUseAuthorization()
        }
        .onChange(of: selectedItem) { oldItem, newItem in
            selectedID = newItem?.value?.id
            isPresentingPlaceInfoDetailView = validateIsPresented(by: newItem)
            
            if isMapKitPOI(of: newItem), let mapFeature = newItem?.feature {
                onSelectItem(MMapItem.from(mapFeature))
            } else {
                if let mapItem = newItem?.value {
                    onSelectItem(mapItem)
                }
            }
        }
        .onChange(of: isPresentingPlaceInfoDetailView) { _, newValue in
            if !newValue { selectedItem = nil }
        }
    }
    
    private func validateIsPresented(by item: MapSelection<MMapItem>?) -> Bool {
        guard let item else { return false }
        return item.value != nil || item.feature != nil
    }
    
    private func isMapKitPOI(of item: MapSelection<MMapItem>?) -> Bool {
        return item?.feature != nil
    }
    
}
