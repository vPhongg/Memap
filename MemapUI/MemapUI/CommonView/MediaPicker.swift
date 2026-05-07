//
//  MediaPicker.swift
//  MemapUI
//
//  Created by Vu Dinh Phong on 06/05/2026.
//

import SwiftUI
import PhotosUI
import Combine

class MediaPickerModel: ObservableObject {
    
    enum LoadingState {
        case empty
        case loading(Progress)
        case success(UIImage)
        case failure(Error)
    }
    
    enum TransferError: Error {
        case importFailed
    }
    
    struct PlaceImage: Transferable {
        let image: UIImage
        
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
#if canImport(AppKit)
                guard let nsImage = NSImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(nsImage: nsImage)
                return ProfileImage(image: image)
#elseif canImport(UIKit)
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                return PlaceImage(image: uiImage)
#else
                throw TransferError.importFailed
#endif
            }
        }
    }
    
    @Published private(set) var loadingState: LoadingState = .empty
    
    @Published var selectedItems: [PhotosPickerItem] = [] {
        didSet {
            guard !selectedItems.isEmpty, let firstItem = selectedItems.first else {
                return loadingState = .empty
            }
            
            let progress = loadTransferable(from: firstItem)
            loadingState = .loading(progress)
        }
    }
    
    // MARK: - Private Methods
    
    private func loadTransferable(from firstSelectedImage: PhotosPickerItem) -> Progress {
        return firstSelectedImage.loadTransferable(type: PlaceImage.self) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                guard let first = self.selectedItems.first, first == firstSelectedImage else {
                    return print("Failed to get the selected item.")
                }
                
                switch result {
                case .success(let profileImage):
                    if let profileImage {
                        self.loadingState = .success(profileImage.image)
                    } else {
                        self.loadingState = .empty
                    }
                case .failure(let error):
                    self.loadingState = .failure(error)
                }
            }
        }
    }
    
}

struct MediaPicker: View {
    @ObservedObject var viewModel: MediaPickerModel
    
    var body: some View {
        PhotosPicker(
            selection: $viewModel.selectedItems,
            maxSelectionCount: 5,
            selectionBehavior: .ordered,
            matching: .all(of: [.images]),
            photoLibrary: .shared()
        ) {
            Image(systemName: "photo.badge.plus.fill")
                .font(.system(size: 18))
        }
    }
}
