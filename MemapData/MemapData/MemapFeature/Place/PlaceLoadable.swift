//
//  PlaceLoadable.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 26/02/2026.
//


public protocol PlaceLoadable {
    func load() async throws -> [Place]
}
