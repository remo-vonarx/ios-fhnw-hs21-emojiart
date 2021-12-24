//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Ramona Marti on 18.11.21.
//

import SwiftUI

struct PaletteChooser: View {
    @ObservedObject var document: EmojiArtDocumentViewModel
    @Binding var chosenPalette: String
    @State private var isPaletteEditorPresented = false

    var body: some View {
        HStack {
            Button(action: {
                chosenPalette = document.palette(before: chosenPalette)
            }) {
                Image(systemName: "arrow.left").imageScale(.large)
            }
            Button(action: {
                chosenPalette = document.palette(after: chosenPalette)
            }) {
                Image(systemName: "arrow.right").imageScale(.large)
            }
            Text(document.paletteNames[chosenPalette] ?? "").imageScale(.large)
            Button {
                isPaletteEditorPresented = true
            } label: {
                Image(systemName: "square.and.pencil").imageScale(.large)
            }
            .sheet(isPresented: $isPaletteEditorPresented) {
                PaletteEditor(chosenPalette: $chosenPalette, document: document)
            }
        }
    }
}
