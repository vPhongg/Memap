//
//  ImagePresentationModel.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 11/05/2026.
//

import Foundation
import MemapData

public struct ImagePresentationModel {
    public let name: String
    public let jpegData: Data
    
    public init(name: String, jpegData: Data) {
        self.name = name
        self.jpegData = jpegData
    }
}

extension Array where Element == ImagePresentationModel {
    func toPhotos() -> [Photo] {
        self.map { Photo(name: $0.name, jpegData: $0.jpegData) }
    }
}
