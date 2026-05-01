//
//  DefaultPlacesListViewModelWrapper.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 14/03/2026.
//

import Foundation

@Observable
public final class DefaultPlacesListViewModelWrapper {
    public var viewModel: PlacesListViewModel
    public var placeGroups = [PlaceGroup]()
    public var numberOfPlaces: String = .empty
    
    public init(viewModel: PlacesListViewModel) {
        self.viewModel = viewModel
        self.viewModel.placeGroups.observe(owner: self) { [weak self] placeGroups in self?.placeGroups = placeGroups }
        self.viewModel.numberOfPlaces.observe(owner: self) { [weak self] numberOfPlaces in self?.numberOfPlaces = numberOfPlaces }
    }
}
