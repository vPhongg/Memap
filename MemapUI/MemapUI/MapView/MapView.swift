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
    
    var didSelectMapKitPOI: (PlaceInfoViewModel) -> Void
    var didDeselectMapKitPOI: () -> Void
    
    public init(
        viewModel: AnyMapViewModel,
        didSelectMapKitPOI: @escaping (PlaceInfoViewModel) -> Void,
        didDeselectMapKitPOI: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.didSelectMapKitPOI = didSelectMapKitPOI
        self.didDeselectMapKitPOI = didDeselectMapKitPOI
    }
    
    public var body: some View {
        MMapView(
            items: viewModel.places.toModels().toMMapItems(),
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
