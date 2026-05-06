//
//  PlaceDetailView.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 02/03/2026.
//


import SwiftUI
import MemapPresentation

public struct PlaceDetailView: View {
    
    @Bindable var viewModel: PlaceDetailViewModel
    
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
                    MediaPicker()
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
                CollectionView(images: [
                    UIImage(named: "random", in: Bundle(identifier: "com.vphong.MemapMap"), with: nil)!,
                    UIImage(named: "swiftui", in: Bundle(identifier: "com.vphong.MemapMap"), with: nil)!,
                ])
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
