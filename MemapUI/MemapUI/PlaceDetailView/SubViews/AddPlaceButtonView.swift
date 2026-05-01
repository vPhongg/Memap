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
    
    var body: some View {
        Button {
            didTapAddPlaceButton()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "plus")
//                Text(PlaceDetailViewModel.addPlaceText)
            }
            .font(.headline)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .foregroundStyle(.white)
            .background(.green, in: Capsule())
        }
    }
    
}
