//
//  PlacesListViewModelInput.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 13/03/2026.
//


public protocol PlacesListViewModelInput {
    func load()
}

public protocol PlacesListViewModelOutput {
    var error: Observable<String> { get }
    var isLoading: Observable<Bool> { get }
    var places: Observable<[PlacePresentationModel]> { get }
    var placeGroups: Observable<[PlaceGroup]> { get }
    var numberOfPlaces: Observable<String> { get }
}

public typealias PlacesListViewModel = PlacesListViewModelInput & PlacesListViewModelOutput
