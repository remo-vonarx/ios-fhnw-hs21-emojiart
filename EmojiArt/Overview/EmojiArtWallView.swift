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
        GridItem(.flexible(minimum: 50)),
        GridItem(.flexible(minimum: 50)),
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
                        createPreviewForDocument(document: document, documentName: name)
                    }.font(customFont)
                }
            }.padding(10)
        }
    }
    
    fileprivate func createPreviewForDocument(document: EmojiArtDocumentViewModel, documentName: String) -> some View {
        VStack {
            if let image = document.backgroundImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .aspectRatio(1, contentMode: .fit)
            }
            Text(documentName).font(customFont)
        }
    }
}
