//
//  PickerImage+Extension.swift
//  MemapUI
//
//  Created by Vu Dinh Phong on 11/05/2026.
//

import Foundation
import MemapPresentation

extension Array where Element == PickerImage {
    func toPresentationModels() -> [ImagePresentationModel] {
        self.map { ImagePresentationModel(name: mapImageName(id: $0.id), jpegData: $0.imageData) }
    }
    
    private func mapImageName(id: String) -> String {
        id + ".jpg"
    }
}
