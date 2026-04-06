//
//  PlaceSaver.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 05/03/2026.
//


public protocol PlaceSaver {
    func save(_ place: PlaceInfo) async throws
}
