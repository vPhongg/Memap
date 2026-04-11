//
//  MapView.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 25/02/2026.
//

import SwiftUI
import MemapMap
import MemapPresentation

public struct MapView: View {
    
    @Bindable private var viewModel: AnyMapViewModel
    
    private let isPresentingPlaceDetailView: Bool
    private let onSavedPlace: Bool
    
    private let didSelectMapKitPOI: (PlaceInfoViewModel) -> Void
    private let didDeselectMapKitPOI: MapItemDeselectionHandler
    
    public init(
        viewModel: AnyMapViewModel,
        isPresentingPlaceDetailView: Bool,
        onSavedPlace: Bool,
        didSelectMapKitPOI: @escaping (PlaceInfoViewModel) -> Void,
        didDeselectMapKitPOI: @escaping MapItemDeselectionHandler
    ) {
        self.viewModel = viewModel
        self.isPresentingPlaceDetailView = isPresentingPlaceDetailView
        self.onSavedPlace = onSavedPlace
        self.didSelectMapKitPOI = didSelectMapKitPOI
        self.didDeselectMapKitPOI = didDeselectMapKitPOI
    }
    
    public var body: some View {
        MMapView(
            items: viewModel.places.toModels().toMMapItems(),
            isPresentingPlaceDetailView: isPresentingPlaceDetailView,
            didSelectMapKitPOI: { item in
                didSelectMapKitPOI(item.toPresentationModel())
            },
            didDeselectMapKitPOI: didDeselectMapKitPOI
        )
        .ignoresSafeArea()
        .overlay {
            if viewModel.isLoading {
                LoadingView()
            } else {
                EmptyView()
            }
        }
        .task {
            do {
                try await self.viewModel.load()
            } catch {
                print("ABC \(error.localizedDescription)")
            }
        }
        .onChange(of: onSavedPlace) { _, _ in
            Task {
                if onSavedPlace {
                     try await self.viewModel.load()
                }
            }
        }
    }
    
}

extension MMapItem {
    func toPresentationModel() -> PlaceInfoViewModel {
        PlaceInfoViewModel(
            id: id,
            name: name,
            latitude: latitude,
            longitude: longitude,
            savedTimestamp: createdTimestamp,
            imagesPath: imagesPath,
            videosPath: videosPath,
            note: note,
            isSaved: isSaved
        )
    }
}

extension Array where Element == PlaceInfoViewModel {
    func toMMapItems() -> [MMapItem] {
        return map {
            MMapItem(
                id: $0.id,
                name: $0.name,
                latitude: $0.latitude,
                longitude: $0.longitude,
                createdTimestamp: $0.savedTimestamp,
                imagesPath: $0.imagesPath,
                videosPath: $0.videosPath,
                note: $0.note,
                isSaved: $0.isSaved
            )
        }
    }
}
