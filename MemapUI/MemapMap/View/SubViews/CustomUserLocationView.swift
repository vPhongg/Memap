//
//  CustomUserLocationView.swift
//  MemapMap
//
//  Created by Vu Dinh Phong on 03/03/2026.
//


import SwiftUI

struct CustomUserLocationView: View {
    
    var body: some View {
        ZStack {
            
            // Pulsing background
            Circle()
                .fill(.blue.opacity(0.2))
                .frame(width: 40, height: 40)
                .scaleEffect(1.0)
                .blur(radius: 4)
            
            // Main blue dot
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.blue, .cyan],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 15, height: 15)
                .overlay(
                    Circle()
                        .stroke(.white, lineWidth: 2)
                )
                .shadow(radius: 6)
        }
    }
}
