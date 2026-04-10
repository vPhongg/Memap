//
//  MainView.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 02/03/2026.
//

import SwiftUI
import MemapPresentation

public struct MainView: View {
    
    @State private var mapViewModel: AnyMapViewModel
    @State private var placeDetailViewModel: PlaceDetailViewModel
    @State private var placesListViewModel: DefaultPlacesListViewModelWrapper
    
    @State private var isPresentingPlaceDetailView: Bool = false
    @State private var isPresentingPlacesListView: Bool = false
    
    public init(
        mapViewModel: AnyMapViewModel,
        placeDetailViewModel: PlaceDetailViewModel,
        placesListViewModel: DefaultPlacesListViewModelWrapper
    ) {
        self.mapViewModel = mapViewModel
        self.placeDetailViewModel = placeDetailViewModel
        self.placesListViewModel = placesListViewModel
    }
    
    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            MapView(
                viewModel: mapViewModel,
                onSelectItem: { item in
                    placeDetailViewModel.model = item
                }
            )
            SideButtonsView(
                didTapSearchButton: {},
                didTapPlacesListButton: {
                    isPresentingPlacesListView = true
                },
                didTapProfileButton: {}
            )
            HStack {
                Spacer()
                QuickShotButtonView()
                Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $isPresentingPlaceDetailView, onDismiss: {
            isPresentingPlaceDetailView = false
        }) {
            PlaceDetailView(viewModel: placeDetailViewModel)
                .presentationDetents([.fraction(0.3), .large])
                .presentationBackgroundInteraction(.enabled)
                .presentationDragIndicator(.visible)
                .presentationBackground(.ultraThinMaterial)
        }
        .sheet(isPresented: $isPresentingPlacesListView, content: {
            PlacesListView(viewModel: mapViewModel)
                .presentationDetents([.large])
        })
    }
}
