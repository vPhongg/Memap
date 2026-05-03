//
//  PlaceRowView.swift
//  MemapUI
//
//  Created by Vu Dinh Phong on 19/04/2026.
//

import SwiftUI
import MemapPresentation

struct PlaceRowView: View {
    
    var place: PlacePresentationModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(place.name)
                .foregroundColor(.primary)
                .font(.headline)
            PlaceAddressView(placeAddress: place.address)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
    
}

#Preview {
    PlaceRowView(place: PlacePresentationModel.defaultObject())
}
