//
//  MediaPicker.swift
//  MemapUI
//
//  Created by Vu Dinh Phong on 06/05/2026.
//

import SwiftUI
import PhotosUI
import Combine

@MainActor
class MediaPickerModel: ObservableObject {
    
    enum LoadingState {
        case empty
        case loading
        case success([UIImage])
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
            guard !selectedItems.isEmpty else {
                return loadingState = .empty
            }
            
            loadingState = .loading
            loadTransferable(for: selectedItems)
        }
    }
    
    // MARK: - Private Methods
    
    private func loadTransferable(for items: [PhotosPickerItem]) {
        typealias Result = (index: Int, image: PlaceImage?)
        
        Task {
            do {
                let images = try await withThrowingTaskGroup(
                    of: Result.self
                ) { group in
                    for (index, item) in items.enumerated() {
                        group.addTask {
                            let image = try await item.loadTransferable(type: PlaceImage.self)
                            return (index, image)
                        }
                    }
                    
                    var result: [Int: PlaceImage] = [:]
                    for try await (index, image) in group {
                        if let image {
                            result[index] = image
                        }
                    }
                    return items.indices.compactMap { result[$0] }
                }
                
                if images.isEmpty {
                    self.loadingState = .empty
                } else {
                    self.loadingState = .success(images.map(\.image))
                }
            } catch {
                self.loadingState = .failure(error)
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
