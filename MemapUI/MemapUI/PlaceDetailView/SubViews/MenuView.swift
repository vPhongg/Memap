//
//  MenuView.swift
//  MemapUI
//
//  Created by Vu Dinh Phong on 01/05/2026.
//

import SwiftUI

struct MenuView: View {
    
    let didTapDeleteButton: () -> Void
    
    var body: some View {
        Menu(content: {
            Button("Delete", systemImage: "trash", role: .destructive) {
                didTapDeleteButton()
            }
            .foregroundStyle(.red)
        },label: {
            Image(systemName: "ellipsis.circle").foregroundStyle(.gray)
        })
    }
    
}
