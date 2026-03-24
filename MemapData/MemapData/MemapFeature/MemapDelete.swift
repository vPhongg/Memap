//
//  MemapDelete.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 19/03/2026.
//


public protocol MemapDelete {
    func delete(_ place: PlaceInfo) async throws
}
