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
        List(viewModel.places.toModels(), id: \.id) { item in
            Text(item.name ?? .empty)
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
