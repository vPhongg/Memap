//
//  PlaceDetailView.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 02/03/2026.
//


import SwiftUI
import MemapPresentation

struct PlaceImagesView: View {
    let loadingState: MediaPickerModel.LoadingState
    
    var body: some View {
        switch loadingState {
        case .success(let image):
            CollectionView(images: [image])
        case .loading:
            ProgressView()
        case .empty:
            EmptyView()
        case .failure:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
        }
    }
}

public struct PlaceDetailView: View {
    
    @Bindable var viewModel: PlaceDetailViewModel
    
    @StateObject var mediaPickerViewModel: MediaPickerModel = MediaPickerModel()
    
    var onSuccessRemoved: (PlacePresentationModel) -> Void
    
    public init(
        viewModel: PlaceDetailViewModel,
        onSuccessRemoved: @escaping (PlacePresentationModel) -> Void
    ) {
        self.viewModel = viewModel
        self.onSuccessRemoved = onSuccessRemoved
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                PlaceNameView(placeName: viewModel.model.name)
                Spacer()
                if viewModel.model.isSaved {
                    MediaPicker(viewModel: mediaPickerViewModel)
                    MenuView(didTapDeleteButton: viewModel.didTapRemovePlaceButton)
                } else {
                    AddPlaceButtonView(didTapAddPlaceButton: viewModel.didTapAddPlaceButton)
                }
            }
            .padding(.top, 2)
            .padding(.bottom, 0.5)
            PlaceAddressView(placeAddress: viewModel.model.address)
                .padding(.bottom, 6)
            if viewModel.model.isSaved {
                PlaceImagesView(loadingState: mediaPickerViewModel.loadingState)
            }
            Spacer()
        }
        .padding()
        .onChange(of: viewModel.removedPlace) { _, place in
            if let place {
                onSuccessRemoved(place)
                viewModel.removedPlace = nil
            }
        }
    }
}
