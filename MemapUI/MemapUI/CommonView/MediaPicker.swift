//
//  MediaPicker.swift
//  MemapUI
//
//  Created by Vu Dinh Phong on 06/05/2026.
//

import SwiftUI
import PhotosUI

struct MediaPicker: View {
    
    @State var imageSelection: PhotosPickerItem? = nil
    
    var body: some View {
        PhotosPicker(selection: $imageSelection,
                     matching: .images,
                     photoLibrary: .shared()) {
            Image(systemName: "photo.badge.plus.fill")
                .font(.system(size: 18))
        }
    }
}

#Preview {
    MediaPicker()
}
