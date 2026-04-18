//
//  MapViewModel.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 26/02/2026.
//


import Foundation
import MemapData

public protocol MapViewModel {
    var isLoading: Bool { get }
    var places: [Place] { get }
    
    func load() async throws -> Void
}
