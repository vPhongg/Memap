//
//  PlacesListView.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 11/03/2026.
//

import SwiftUI
import MemapPresentation

struct PersonRowView: View {
    var place: PlacePresentationModel


    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(place.name)
                .foregroundColor(.primary)
                .font(.headline)
            HStack(spacing: 3) {
                Label(place.name, systemImage: "phone")
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
    }
}

struct PlacesListView: View {
    
    @Bindable var viewModel: AnyMapViewModel
    
    var body: some View {
        List(viewModel.places.toModels(), id: \.id) { item in
            Text(item.name)
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
