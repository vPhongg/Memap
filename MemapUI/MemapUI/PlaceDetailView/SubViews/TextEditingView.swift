//
//  TextEditingView.swift
//  MemapUI
//
//  Created by Vu Dinh Phong on 11/05/2026.
//

import SwiftUI

struct PlaceNoteView: View {
    @State private var fullText: String = ""
    
    var body: some View {
        TextEditor(text: $fullText)
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
            .background(Color.clear)
            .foregroundColor(Color.gray)
            .font(.custom("HelveticaNeue", size: 16))
            .lineSpacing(5)
    }
}
