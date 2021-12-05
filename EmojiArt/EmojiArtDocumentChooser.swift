//
//  EmojiArtDocumentChooser.swift
//  EmojiArt
//
//  Created by Remo von Arx on 28.11.21.
//

import SwiftUI

struct EmojiArtDocumentChooser: View {
    @ObservedObject var store: EmojiArtDocumentStore
    @State private var editMode = EditMode.inactive

    private var initialDetailView: some View {
        let document = store.documents.first ?? EmojiArtDocumentViewModel()
        return EmojiArtDocumentView(document: document)
            .navigationTitle(store.name(for: document))
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(store.documents) { document in
                    let emojiArtDocumentView = EmojiArtDocumentView(document: document)
                        .navigationTitle(store.name(for: document))
                    NavigationLink(destination: emojiArtDocumentView) {
                        EditableText(store.name(for: document), isEditing: editMode.isEditing, onChanged: { name in
                            store.setName(name, for: document)
                        })
                    }
                }
                .onDelete { indexSet in
                    indexSet
                        .map { store.documents[$0] }
                        .forEach { store.removeDocument($0) }
                }
            }
            .navigationBarTitle(store.name)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        store.addDocument()
                    }) {
                        Image(systemName: "plus").imageScale(.large)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: createEmojiArtWallView()) {
                        Image(systemName: "square.grid.2x2.fill").imageScale(.large)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .environment(\.editMode, $editMode)

            createInitialDetailView()
        }
    }

    private func createInitialDetailView() -> some View {
        let document = store.documents.first ?? store.addDocument()
        return EmojiArtDocumentView(document: document)
            .navigationTitle(store.name(for: document))
    }

    private func createEmojiArtWallView() -> some View {
        return EmojiArtWallView(store: store)
            .navigationTitle("Emoji Art Wall")
    }
}
