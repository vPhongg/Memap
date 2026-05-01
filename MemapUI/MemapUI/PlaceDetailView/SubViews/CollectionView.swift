//
//  CollectionView.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 06/03/2026.
//


import SwiftUI

struct CollectionView: View {
    
    let images: [UIImage]
    
    private static let size: CGFloat = 100.0
    private static let spacing: CGFloat = 12.0
    private static let cornerRadius: CGFloat = 12.0
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack() {
                ForEach(images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: CollectionView.size, height: CollectionView.size)
                        .clipped()
                        .cornerRadius(CollectionView.cornerRadius)
                }
            }
        }
    }
}
