//
//  GroupHeaderView.swift
//  MemapUI
//
//  Created by Vu Dinh Phong on 30/04/2026.
//

import SwiftUI

struct GroupHeaderView: View {
    let title: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(color)
            Image(systemName: "info.circle")
                .scaledToFit()
            Spacer()
        }
    }
    
}
