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
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                PlaceNameView(placeName: viewModel.model.name)
                Spacer()
                if viewModel.model.isSaved {
                    Button("", systemImage: "photo.badge.plus.fill", action: {
                        print("Add Photos")
                    })
                    
                    MenuView(didTapDeleteButton: viewModel.didTapRemovePlaceButton)
                } else {
                    AddPlaceButtonView(didTapAddPlaceButton: viewModel.didTapAddPlaceButton)
                }
            }
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
