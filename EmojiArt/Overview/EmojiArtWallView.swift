//
//  EmojiArtWallView.swift
//  EmojiArt
//
//  Created by Remo von Arx on 02.12.21.
//

import SwiftUI

struct EmojiArtWallView: View {
    var store: EmojiArtDocumentStore
    @Environment(\.font) private var customFont: Font?

    init(store: EmojiArtDocumentStore) {
        self.store = store
    }

    let columns = [
        GridItem(.flexible(minimum: columnSize)),
        GridItem(.flexible(minimum: columnSize)),
    ]

    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, alignment: .center) {
                ForEach(store.documents, id: \.self) { document in
                    let name = store.name(for: document)
                    let emojiArtDocumentView = EmojiArtDocumentView(document: document)
                        .navigationTitle(name)
                        .font(customFont)
                    NavigationLink(destination: emojiArtDocumentView) {
                        EmojiArtDocumentPreview(document: document, documentName: name).font(customFont)
                    }.font(customFont)
                }
            }.padding(10)
        }
    }
}

// MARK: - Drawing constants

private let columnSize: CGFloat = 50
