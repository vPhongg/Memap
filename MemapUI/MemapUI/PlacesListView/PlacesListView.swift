//
//  PlacesListView.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 11/03/2026.
//

import SwiftUI
import MemapPresentation

struct PlacesListView: View {
    
    @Bindable var viewModel: DefaultPlacesListViewModelWrapper
    
    let didSelectPlace: (PlacePresentationModel) -> Void
    
    var body: some View {
        List {
            ForEach(viewModel.placeGroups) { group in
                Section(header: Text(group.title)) {
                    ForEach(group.places) { place in
                        PlaceRowView(place: place)
                            .onTapGesture {
                                didSelectPlace(place)
                            }
                    }
                }
            }
        }
        .task {
            self.viewModel.viewModel.load()
        }
    }
    
}
