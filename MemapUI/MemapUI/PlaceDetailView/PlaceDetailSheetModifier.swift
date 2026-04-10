//
//  PlaceDetailSheetModifier.swift
//  MemapUI
//
//  Created by Vu Dinh Phong on 10/04/2026.
//

import SwiftUI
import MemapPresentation

struct PlaceDetailSheetModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    
    let viewModel: PlaceDetailViewModel
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented, onDismiss: {
                isPresented = false
            }) {
                PlaceDetailView(viewModel: viewModel)
                    .presentationDetents([.fraction(0.3), .large])
                    .presentationBackgroundInteraction(.enabled)
                    .presentationDragIndicator(.visible)
                    .presentationBackground(.ultraThinMaterial)
            }
    }
    
}

extension View {
    func showDetailView(
        isPresented: Binding<Bool>,
        viewModel: PlaceDetailViewModel
    ) -> some View {
        self.modifier(
            PlaceDetailSheetModifier(
                isPresented: isPresented,
                viewModel: viewModel
            )
        )
    }
}
