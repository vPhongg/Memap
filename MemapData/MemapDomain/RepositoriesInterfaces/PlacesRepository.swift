//
//  PlacesRepository.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 11/03/2026.
//


public protocol PlacesRepository {
    func fetchPlacesList(completion: @escaping (Result<[PlaceInfoDomain], Error>) -> Void)
}
