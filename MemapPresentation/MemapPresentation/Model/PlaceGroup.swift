//
//  PlaceGroup.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 19/04/2026.
//

import Foundation

public struct PlaceGroup: Identifiable {
    public let id = UUID()
    public let name: String
    public let places: [PlacePresentationModel]
    
    public init(name: String, places: [PlacePresentationModel]) {
        self.name = name
        self.places = places
    }
}
