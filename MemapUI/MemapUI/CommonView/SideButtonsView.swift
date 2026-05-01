//
//  SideButtonsView.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 14/03/2026.
//

import SwiftUI

struct SideButtonsView: View {
    
    let didTapSearchButton: () -> Void
    let didTapPlacesListButton: () -> Void
    let didTapProfileButton: () -> Void
    
    var body: some View {
        VStack {
//            ReusableButtonView(
//                symbolName: "magnifyingglass",
//                didTapButton: didTapSearchButton
//            )
            ReusableButtonView(
                symbolName: "list.bullet",
                didTapButton: didTapPlacesListButton
            )
//            ReusableButtonView(
//                symbolName: "person.crop.circle",
//                didTapButton: didTapProfileButton)
        }
        .padding()
    }
}
