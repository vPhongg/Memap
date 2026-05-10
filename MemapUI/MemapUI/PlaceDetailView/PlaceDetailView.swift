//
//  PlaceDetailView.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 02/03/2026.
//


import SwiftUI
import MemapPresentation

struct TextEditingView: View {
    @State private var fullText: String = ""
    
    
    var body: some View {
        TextEditor(text: $fullText)
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
            .background(Color.clear)
            .foregroundColor(Color.gray)
            .font(.custom("HelveticaNeue", size: 16))
            .lineSpacing(5)
    }
}

public struct PlaceDetailView: View {
    
    @Bindable var viewModel: PlaceDetailViewModel
    
    @StateObject var mediaPickerViewModel: MediaPickerViewModel = MediaPickerViewModel()
    
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
                    HStack(spacing: 16) {
                        MediaPicker(viewModel: mediaPickerViewModel)
                        MenuView(didTapDeleteButton: viewModel.didTapRemovePlaceButton)
                    }
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
            TextEditingView()
            Spacer()
        }
        .padding()
        .onChange(of: viewModel.removedPlace) { _, place in
            if let place {
                onSuccessRemoved(place)
                viewModel.removedPlace = nil
            }
        }
        .onChange(of: mediaPickerViewModel.loadingState) { _, newState in
            if case .success(let images) = newState {
                viewModel.save(images.toPresentationModels(), placeID: viewModel.model.id)
            }
        }
    }
}

extension Array where Element == PickerImage {
    func toPresentationModels() -> [ImagePresentationModel] {
        self.map { ImagePresentationModel(name: mapImageName(id: $0.id), jpegData: $0.imageData) }
    }
    
    private func mapImageName(id: String) -> String {
        id + ".jpg"
    }
}
