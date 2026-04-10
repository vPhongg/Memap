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
    @State private var placeInfoDetailViewModel: PlaceDetailViewModel
    @State private var placesListViewModel: DefaultPlacesListViewModelWrapper
    
    @State private var isPresentingPlaceInfoDetailView: Bool = false
    @State private var isPresentingPlacesListView: Bool = false
    
    public init(
        mapViewModel: AnyMapViewModel,
        placeInfoDetailViewModel: PlaceDetailViewModel,
        placesListViewModel: DefaultPlacesListViewModelWrapper
    ) {
        self.mapViewModel = mapViewModel
        self.placeInfoDetailViewModel = placeInfoDetailViewModel
        self.placesListViewModel = placesListViewModel
    }
    
    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            MapView(
                isPresentingPlaceInfoDetailView: isPresentingPlaceInfoDetailView,
                viewModel: mapViewModel,
                onSelectItem: { item in
                    placeInfoDetailViewModel.model = item
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
        .showDetailView(
            isPresented: $isPresentingPlaceInfoDetailView,
            viewModel: placeInfoDetailViewModel
        )
        .sheet(isPresented: $isPresentingPlacesListView, content: {
            PlacesListView(viewModel: mapViewModel)
                .presentationDetents([.large])
        })
    }
}
