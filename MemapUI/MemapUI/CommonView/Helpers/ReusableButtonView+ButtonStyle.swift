//
//  LiquidGlassButtonStyle.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 14/03/2026.
//


import SwiftUI

struct LiquidGlassButtonStyle<S: ShapeStyle>: ButtonStyle{
    let backgroundStyle: S
    let backgroundOpacity: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                Circle()
                    .fill(backgroundStyle).opacity(configuration.isPressed ? 0.99 : backgroundOpacity)
            )
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: configuration.isPressed)
            .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
    }
    
}
