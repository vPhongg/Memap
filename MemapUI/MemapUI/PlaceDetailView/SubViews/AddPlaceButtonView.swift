//
//  AddPlaceView.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 05/03/2026.
//

import SwiftUI
import MemapPresentation

struct AddPlaceButtonView: View {
    
    let didTapAddPlaceButton: () -> Void
    let didTapRemovePlaceButton: () -> Void
    var isSaved: Bool
    
    var body: some View {
        Button {
            isSaved ? didTapRemovePlaceButton() : didTapAddPlaceButton()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: isSaved ? "minus" : "plus")
                Text(isSaved
                     ? PlaceDetailViewModel.removePlaceText
                     : PlaceDetailViewModel.addPlaceText)
            }
            .font(isSaved ? .subheadline : .headline)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .foregroundStyle(.white)
            .background(isSaved ? .red : .green, in: Capsule())
        }
    }
    
}
