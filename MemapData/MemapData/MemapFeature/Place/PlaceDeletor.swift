//
//  PlaceDeletor.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 19/03/2026.
//


public protocol PlaceDeletor {
    func delete(_ place: Place) async throws
}
