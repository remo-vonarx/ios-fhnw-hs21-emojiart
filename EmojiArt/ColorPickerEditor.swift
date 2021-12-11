//
//  ColorPicker.swift
//  EmojiArt
//
//  Created by Ramona Marti on 11.12.21.
//

import SwiftUI

struct ColorPickerEditor: View {
    @ObservedObject var document: EmojiArtDocumentViewModel
    @State private var backgroundColor: Color
    @State private var opacity: Double

    init(document: EmojiArtDocumentViewModel) {
        self.document = document
        backgroundColor = document.backgroundColor
        opacity = document.opacity
    }

    var body: some View {
        VStack {
            Text("Background Color Editor")
                .font(.headline)
                .padding()
            Form {
                ColorPicker("Background Color", selection: $backgroundColor)
                Slider(value: $opacity)
                Button(action: {
                    document.backgroundColor = backgroundColor
                    document.opacity = opacity
                }) {
                    Text("Done")
                }
            }
        }
    }
}
