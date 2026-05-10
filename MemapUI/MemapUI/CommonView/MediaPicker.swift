//
//  MediaPicker.swift
//  MemapUI
//
//  Created by Vu Dinh Phong on 06/05/2026.
//

import SwiftUI
import PhotosUI
import Combine

public struct PickerImage: Equatable {
    public let id: String
    public let imageData: Data
    
    public init(id: String, imageData: Data) {
        self.id = id
        self.imageData = imageData
    }
}

@MainActor
class MediaPickerViewModel: ObservableObject {
    
    enum LoadingState: Equatable {
        case empty
        case loading
        case success([PickerImage])
        case failure(TransferError)
    }
    
    enum TransferError: Error, Equatable {
        case importFailed
        case failedTaskGroup
    }
    
    private struct LocalImage: Transferable {
        let imageData: Data
        
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
#if canImport(AppKit)
                return PlaceImage(imageData: data)
#elseif canImport(UIKit)
                return LocalImage(imageData: data)
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
        typealias Result = (index: Int, image: PickerImage?)
        
        Task {
            do {
                let images = try await withThrowingTaskGroup(
                    of: Result.self
                ) { group in
                    for (index, item) in items.enumerated() {
                        group.addTask {
                            let image = try await item.loadTransferable(type: LocalImage.self)
                            if let image, let imageID = item.itemIdentifier {
                                let pickerImage = PickerImage(id: createImageID(id: imageID), imageData: image.imageData)
                                return (index, pickerImage)
                            }
                            return (index, nil)
                        }
                    }
                    
                    var result: [Int: PickerImage] = [:]
                    for try await (index, image) in group {
                        result[index] = image
                    }
                    return items.indices.compactMap { result[$0] }
                }
                
                if images.isEmpty {
                    self.loadingState = .empty
                } else {
                    self.loadingState = .success(images)
                }
            } catch {
                self.loadingState = .failure(.failedTaskGroup)
            }
        }
        
        nonisolated func createImageID(id: String) -> String {
            return id.replacingOccurrences(of: "/", with: "-")
        }
    }
    
}

struct MediaPicker: View {
    @ObservedObject var viewModel: MediaPickerViewModel
    
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
