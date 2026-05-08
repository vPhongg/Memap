//
//  PlaceSavable.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 05/03/2026.
//


public protocol PlaceSavable {
    func save(_ place: Place) async throws
}
