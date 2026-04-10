//
//  PlaceDetailView.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 02/03/2026.
//


import SwiftUI
import MemapPresentation

struct PlaceDetailView: View {
    
    @Bindable var viewModel: PlaceDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                PlaceNameView(placeName: viewModel.model.name.defaultUnknown)
                Spacer()
                AddPlaceButtonView(
                    didTapAddPlaceButton: viewModel.didTapAddPlaceButton,
                    didTapRemovePlaceButton: viewModel.didTapRemovePlaceButton,
                    isAdded: viewModel.model.isAdded
                )
            }
            CollectionView(images: [])
            Spacer()
        }
        .padding()
    }
}
