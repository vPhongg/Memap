//
//  PlacesListView.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 11/03/2026.
//

import SwiftUI
import MemapPresentation

struct PlacesListView: View {
    
    @Bindable var viewModel: AnyMapViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.placeGroups) { group in
                Section(header: Text(group.name)) {
                    ForEach(group.places) { place in
                        PlaceRowView(place: place)
                            .onTapGesture {
                                print(place.name)
                            }
                    }
                }
            }
         }
        .task {
            do {
                try await self.viewModel.load()
            } catch {
                print("ABC \(error.localizedDescription)")
            }
        }
    }
    
}
