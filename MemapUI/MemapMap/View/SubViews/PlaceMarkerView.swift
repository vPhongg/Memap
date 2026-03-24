//
//  ImageView.swift
//  MemapMap
//
//  Created by Vu Dinh Phong on 02/03/2026.
//


import SwiftUI

struct PlaceMarkerView: View {
    var title: String
    var size: CGFloat
    let isActive: Bool
    
    private let cornerRadius: CGFloat = 6.0
    private var imageSize: CGFloat {
        size - 1.0
    }
    
    private var lineWidth: CGFloat {
        isActive ? 3 : 1.5
    }
    
    private var strokeColor: Color {
        isActive ? .green : .gray.opacity(0.5)
    }
    
    private var scaleEffect: CGFloat {
        isActive ? 1.25 : 1
    }
    
    private var animationStyle: Animation {
        .spring(response: 0.4, dampingFraction: 0.7)
    }
    
    public init(title: String = "",
                size: CGFloat,
                isActive: Bool
    ) {
        self.title = title
        self.size = size
        self.isActive = isActive
    }
    
    public var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white)
                    .stroke(strokeColor, lineWidth: lineWidth)
                    .frame(width: size, height: size)
                    .scaleEffect(scaleEffect)
                    .animation(animationStyle, value: isActive)
                
                Image(systemName: "photo.badge.plus.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.gray)
                    .backgroundStyle(.black)
                    .padding(2)
                    .frame(width: imageSize, height: imageSize)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    .scaleEffect(scaleEffect)
                    .animation(animationStyle, value: isActive)
            }
            Text(title)
                .font(.subheadline.weight(.medium))
        }
        
    }
}

#Preview {
    PlaceMarkerView(size: 39, isActive: false)
}
