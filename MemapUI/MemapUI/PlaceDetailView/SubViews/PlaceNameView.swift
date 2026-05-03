//
//  PlaceNameView.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 06/03/2026.
//


import SwiftUI

struct PlaceNameView: View {
    var placeName: String
    
    var body: some View {
        Text(placeName)
            .font(.title3.weight(.semibold))
    }
}

