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
    @State private var isPlaceSaved: Bool = false
    @State private var removedPlace: PlacePresentationModel?
    @State private var selectedPlace: PlacePresentationModel?
    
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
                isPresentingPlaceDetailView: isPresentingPlaceDetailView,
                isPlaceSaved: placeDetailViewModel.model.isSaved,
                removedPlace: removedPlace,
                selectedPlace: selectedPlace,
                didSelectMapKitPOI: { item in
                    isPresentingPlaceDetailView = true
                    placeDetailViewModel.model = item
                },
                didDeselectMapKitPOI: {
                    if isPresentingPlaceDetailView {
                        isPresentingPlaceDetailView = false
                    }
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
            PlaceDetailView(
                viewModel: placeDetailViewModel,
                onSuccessRemoved: { place in
                    isPresentingPlaceDetailView = false
                    removedPlace = place
                }
            )
            .presentationDetents([.fraction(0.3), .large])
            .presentationBackgroundInteraction(.enabled)
            .presentationDragIndicator(.visible)
            .presentationBackground(.ultraThinMaterial)
        }
        .sheet(isPresented: $isPresentingPlacesListView, content: {
            PlacesListView(
                viewModel: placesListViewModel,
                didSelectPlace: { place in
                    selectedPlace = place
                    isPresentingPlacesListView = false
                })
            .presentationDetents([.large])
        })
    }
}
