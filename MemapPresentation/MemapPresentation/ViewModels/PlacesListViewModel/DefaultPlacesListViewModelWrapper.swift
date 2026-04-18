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
    public var places = [PlacePresentationModel]()
    
    public init(viewModel: PlacesListViewModel) {
        self.viewModel = viewModel
        self.viewModel.places.observe(owner: self) { [weak self] places in self?.places = places }
    }
}
