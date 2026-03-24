//
//  Cancellable.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 13/03/2026.
//


public protocol Cancellable {
    func cancel()
}

public protocol LoadPlacesUseCase {
    func execute(completion: @escaping (Result<[PlaceInfoDomain], Error>) -> Void)
}