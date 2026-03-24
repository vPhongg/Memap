//
//  PlacesListButtonView.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 14/03/2026.
//

import SwiftUI

struct ReusableButtonView<S: ShapeStyle>: View {
    let symbolName: String
    let size: CGFloat
    let foregroundColor: Color
    let foregroundOpacity: CGFloat
    let backgroundStyle: S
    let backgroundOpacity: CGFloat
    
    let didTapButton: () -> Void
    
    init(
        symbolName: String,
        size: CGFloat = 50,
        foregroundColor: Color = .primary,
        foregroundOpacity: CGFloat = 0.66,
        backgroundStyle: S = .thinMaterial,
        backgroundOpacity: CGFloat = 0.88,
        didTapButton: @escaping () -> Void,
    ) {
        self.symbolName = symbolName
        self.size = size
        self.foregroundColor = foregroundColor
        self.foregroundOpacity = foregroundOpacity
        self.backgroundStyle = backgroundStyle
        self.backgroundOpacity = backgroundOpacity
        self.didTapButton = didTapButton
    }
    
    var body: some View {
        Button {
            didTapButton()
        } label: {
            Image(systemName: symbolName)
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(foregroundColor).opacity(foregroundOpacity)
                .frame(width: size, height: size)
        }
        .buttonStyle(
            LiquidGlassButtonStyle(
            backgroundStyle: backgroundStyle,
            backgroundOpacity: backgroundOpacity
            )
        )
    }
}

#Preview {
//    ReusableButtonView(symbolName: "list.bullet")
}
