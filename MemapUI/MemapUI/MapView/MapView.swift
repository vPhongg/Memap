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
    private let isPlaceSaved: Bool
    private var removedPlace: PlacePresentationModel?
    private var selectedPlaceID: String?
    
    private let didSelectMapKitPOI: (PlacePresentationModel) -> Void
    private let didDeselectMapKitPOI: MapItemDeselectionHandler
    
    public init(
        viewModel: AnyMapViewModel,
        isPresentingPlaceDetailView: Bool,
        isPlaceSaved: Bool,
        removedPlace: PlacePresentationModel?,
        selectedPlaceID: String?,
        didSelectMapKitPOI: @escaping (PlacePresentationModel) -> Void,
        didDeselectMapKitPOI: @escaping MapItemDeselectionHandler
    ) {
        self.viewModel = viewModel
        self.isPresentingPlaceDetailView = isPresentingPlaceDetailView
        self.isPlaceSaved = isPlaceSaved
        self.removedPlace = removedPlace
        self.selectedPlaceID = selectedPlaceID
        self.didSelectMapKitPOI = didSelectMapKitPOI
        self.didDeselectMapKitPOI = didDeselectMapKitPOI
    }
    
    public var body: some View {
        MMapView(
            items: viewModel.places.toPresentationModels().toMMapItems(),
            selectedPlaceID: selectedPlaceID,
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
        .onChange(of: isPlaceSaved) { _, _ in
            Task {
                if isPlaceSaved {
                     try await self.viewModel.load()
                }
            }
        }
        .onChange(of: removedPlace) { _, place in
            if let place {
                Task {
                    try await self.viewModel.load()
                }
            }
        }
    }
    
}

extension MMapItem {
    func toPresentationModel() -> PlacePresentationModel {
        PlacePresentationModel(
            id: id,
            name: name ?? .empty,
            latitude: latitude,
            longitude: longitude,
            savedTimestamp: createdTimestamp,
            imagesPath: imagesPath,
            videosPath: videosPath,
            note: note,
            isSaved: isSaved,
            backgroundColor: backgroundColor?.toHexString() ?? "",
            type: type.toPlaceTypePresentationModel()
        )
    }
}

extension Optional where Wrapped == PlacePresentationModel {
    func toMMapItem() -> MMapItem? {
        guard let self else { return nil }
        return self.toMMapItem()
    }
}

extension PlacePresentationModel {
    func toMMapItem() -> MMapItem {
        MMapItem(
            id: self.id,
            name: self.name,
            latitude: self.latitude,
            longitude: self.longitude,
            createdTimestamp: self.savedTimestamp,
            imagesPath: self.imagesPath,
            videosPath: self.videosPath,
            note: self.note,
            isSaved: self.isSaved,
            backgroundColor: UIColor(hex: backgroundColor),
            type: self.type.toMapItemType()
        )
    }
}

extension Array where Element == PlacePresentationModel {
    func toMMapItems() -> [MMapItem] {
        return map { $0.toMMapItem() }
    }
}

extension MapItemType {
    func toPlaceTypePresentationModel() -> PlaceTypePresentationModel {
        if let type = PlaceTypePresentationModel(rawValue: self.rawValue) {
            return type
        } else {
            return .unknown
        }
    }
}

extension PlaceTypePresentationModel {
    func toMapItemType() -> MapItemType {
        if let type = MapItemType(rawValue: self.rawValue) {
            return type
        } else {
            return .unknown
        }
    }
}
