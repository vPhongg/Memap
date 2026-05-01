//
//  CollectionImageView.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 06/03/2026.
//

import SwiftUI

struct CollectionItemView: View {
    private static let size: CGFloat = 100.0
    private static let spacing: CGFloat = 12.0
    private static let cornerRadius: CGFloat = 12.0
    
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: CollectionItemView.size, height: CollectionItemView.size)
            .clipped()
            .cornerRadius(CollectionItemView.cornerRadius)
    }
}
