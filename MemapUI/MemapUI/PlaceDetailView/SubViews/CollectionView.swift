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
    private static let spacing: CGFloat = 20.0
    
    let rows = [
        GridItem(.fixed(size), spacing: spacing),
        GridItem(.fixed(size))
    ]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
//                LazyHGrid(rows: rows, spacing: CollectionView.spacing) {
//                    ForEach(0...300, id: \.self) { each in
//                        Color.red.frame(width: CollectionView.size)
//                        Color.green.frame(width: CollectionView.size)
//                    }
//                    ForEach(model.images, id: \.self) { image in
//                        CollectionItemView(image: image)
//                    }
//                }
            }
        }
        .frame(maxWidth: 500)
    }
}
