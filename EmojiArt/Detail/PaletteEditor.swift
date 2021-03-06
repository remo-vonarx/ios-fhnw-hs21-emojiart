//
//  PaletteEditor.swift
//  EmojiArt
//
//  Created by Ramona Marti on 25.11.21.
//

import SwiftUI

struct PaletteEditor: View {
    @Binding var chosenPalette: String
    @ObservedObject var document: EmojiArtDocumentViewModel
    @State private var paletteNameInput: String
    @State private var emojiToAdd: String = ""

    init(chosenPalette: Binding<String>, document: EmojiArtDocumentViewModel) {
        _chosenPalette = chosenPalette
        self.document = document
        paletteNameInput = document.paletteNames[chosenPalette.wrappedValue] ?? ""
    }

    var body: some View {
        VStack {
            Text("Palette Editor")
                .font(.headline)
                .padding()
            Form {
                TextField("Palette Name", text: $paletteNameInput, onEditingChanged: { isEditing in
                    if !isEditing {
                        document.renamePalette(chosenPalette, to: paletteNameInput)
                    }
                })
                TextField("Add Emojiy", text: $emojiToAdd, onEditingChanged: { isEditing in
                    if !isEditing {
                        chosenPalette = document.addEmoji(emojiToAdd, toPalette: chosenPalette)
                        emojiToAdd = ""
                    }
                })
                Section(header: Text("Remove Emojis"), content: {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                        ForEach(chosenPalette.map { String($0) }, id: \.self) { emoji in
                            Text(emoji)
                                .font(.system(size: 40))
                                .onTapGesture {
                                    withAnimation {
                                        chosenPalette = document.removeEmojis(emoji, fromPalette: chosenPalette)
                                    }
                                }
                        }
                    }
                })
            }
        }
    }
}
