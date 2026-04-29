//
//  PlaceGroup.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 19/04/2026.
//

import Foundation

public struct PlaceGroup: Identifiable {
    public let id = UUID()
    public let title: String
    public let type: PlaceTypePresentationModel
    public var places: [PlacePresentationModel]
    
    public init(title: String, type: PlaceTypePresentationModel, places: [PlacePresentationModel]) {
        self.title = title
        self.type = type
        self.places = places
    }
}
