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
    var isAdded: Bool
    
    var body: some View {
        Button {
            isAdded ? didTapRemovePlaceButton() : didTapAddPlaceButton()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: isAdded ? "minus" : "plus")
                Text(isAdded
                     ? PlaceInfoDetailViewModel.removePlaceText
                     : PlaceInfoDetailViewModel.addPlaceText)
            }
            .font(isAdded ? .subheadline : .headline)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .foregroundStyle(.white)
            .background(isAdded ? .red : .green, in: Capsule())
        }
    }
    
}
