//
//  MapView.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 25/02/2026.
//

import SwiftUI
import MemapMap
import MemapPresentation

struct MapView: View {
    
    @Binding var isPresentingPlaceInfoDetailView: Bool
    @Bindable var viewModel: AnyMapViewModel
    
    var onSelectItem: (PlaceInfoViewModel) -> Void
    
    var body: some View {
        //        MMap(
        //            items: viewModel.places.toModels().toMMapItems(),
        //            isPresentingPlaceInfoDetailView: $isPresentingPlaceInfoDetailView,
        //            onSelectItem: { item in
        //                onSelectItem(item.toPresentationModel())
        //            }
        //        )
        
        MMapView(
            mapItems: viewModel.places.toModels().toMMapItems(),
            isPresentingPlaceInfoDetailView: $isPresentingPlaceInfoDetailView,
            onSelectItem: { item in
                onSelectItem(item.toPresentationModel())
            }
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
    }
    
}

extension MMapItem {
    func toPresentationModel() -> PlaceInfoViewModel {
        PlaceInfoViewModel(
            id: id,
            name: name,
            latitude: latitude,
            longitude: longitude,
            createdTimestamp: createdTimestamp,
            imagePath: imagePath,
            isAdded: isAdded
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
                createdTimestamp: $0.createdTimestamp,
                imagePath: $0.imagePath,
                isAdded: $0.isAdded
            )
        }
    }
}
