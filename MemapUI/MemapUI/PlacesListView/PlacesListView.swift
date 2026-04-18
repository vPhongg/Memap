//
//  PlacesListView.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 11/03/2026.
//

import SwiftUI
import MemapPresentation

struct PlaceGroup: Identifiable {
    let id = UUID()
    var name: String
    var places: [PlacePresentationModel]
}

struct PlaceRowView: View {
    
    var place: PlacePresentationModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(place.name)
                .foregroundColor(.primary)
                .font(.headline)
            HStack(spacing: 3) {
                Text(place.name)
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
    }
    
}

struct PlacesListView: View {
    
    @Bindable var viewModel: AnyMapViewModel
    
    var placeGroups = [
        PlaceGroup(name: "Eating", places: [
            PlacePresentationModel.defaultObject(),
            PlacePresentationModel.defaultObject(),
        ]),
        PlaceGroup(name: "Store", places: [
            PlacePresentationModel.defaultObject(),
            PlacePresentationModel.defaultObject(),
        ]),
        PlaceGroup(name: "Tourism", places: [
            PlacePresentationModel.defaultObject(),
            PlacePresentationModel.defaultObject(),
        ]),
    ]
    
    var body: some View {
        List {
            ForEach(placeGroups) { group in
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
