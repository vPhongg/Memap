//
//  PlaceImagesView.swift
//  MemapUI
//
//  Created by Vu Dinh Phong on 08/05/2026.
//

import SwiftUI
import MemapPresentation

struct PlaceImagesView: View {
    let imageState: ImageState
    
    var body: some View {
        switch imageState {
        case .success(let images):
            CollectionView(images: images)
        case .loading:
            ProgressView()
        case .empty:
            EmptyView()
        case .failure:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
        }
    }
}
