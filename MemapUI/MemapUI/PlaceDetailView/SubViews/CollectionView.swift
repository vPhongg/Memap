//
//  CollectionView.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 06/03/2026.
//


import SwiftUI

struct CollectionView: View {
    
    let images: [UIImage]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack() {
                ForEach(images, id: \.self) { image in
                    CollectionItemView(image: image)
                        .onTapGesture {
                            print("Image tapped")
                        }
                }
            }
        }
    }
}
