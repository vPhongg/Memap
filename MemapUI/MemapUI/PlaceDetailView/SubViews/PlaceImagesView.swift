//
//  PlaceImagesView.swift
//  MemapUI
//
//  Created by Vu Dinh Phong on 08/05/2026.
//

import SwiftUI

struct PlaceImagesView: View {
    let loadingState: MediaPickerViewModel.LoadingState
    
    var body: some View {
        switch loadingState {
        case .success(let images):
            CollectionView(images: images.compactMap { UIImage(data: $0.imageData) })
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
