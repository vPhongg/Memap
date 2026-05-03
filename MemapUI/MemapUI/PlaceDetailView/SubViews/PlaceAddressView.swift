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
        HStack(spacing: 3) {
            Text(placeAddress)
        }
        .foregroundColor(.secondary)
        .font(.subheadline)
    }
}