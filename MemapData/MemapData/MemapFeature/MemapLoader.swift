//
//  MemapLoader.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 26/02/2026.
//


public protocol MemapLoader {
    func load() async throws -> [PlaceInfo]
}
