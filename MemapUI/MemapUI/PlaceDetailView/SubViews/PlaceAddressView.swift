//
//  PlaceAddressView.swift
//  MemapUI
//
//  Created by Vu Dinh Phong on 03/05/2026.
//

import SwiftUI

struct PlaceAddressView: View {
    var placeAddress: String
    
    var body: some View {
        HStack(alignment: .center) {
            Text(placeAddress)
        }
        .lineLimit(nil)
        .multilineTextAlignment(.leading)
        .fixedSize(horizontal: false, vertical: true)
        .foregroundColor(.secondary)
        .font(.subheadline)
    }
}
