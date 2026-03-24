//
//  LoadingView.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 26/02/2026.
//


import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.25).ignoresSafeArea()
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(2.0)
                .padding()
                .foregroundColor(.white)
        }
    }
}
