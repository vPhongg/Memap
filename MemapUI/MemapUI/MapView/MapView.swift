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
    
    @State var viewModel: AnyMapViewModel
    
    var onSelectItem: (PlaceInfoViewModel) -> Void
    
    public init(
        isPresentingPlaceInfoDetailView: Bool,
        viewModel: AnyMapViewModel,
        onSelectItem: @escaping (PlaceInfoViewModel) -> Void
    ) {
        self.viewModel = viewModel
        self.onSelectItem = onSelectItem
    }
    
    public var body: some View {
        MMapView(
            items: viewModel.places.toModels().toMMapItems(),
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
            savedTimestamp: createdTimestamp,
            imagesPath: imagesPath,
            videosPath: videosPath,
            note: note,
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
                createdTimestamp: $0.savedTimestamp,
                imagesPath: $0.imagesPath,
                videosPath: $0.videosPath,
                note: $0.note,
                isAdded: $0.isAdded
            )
        }
    }
}
