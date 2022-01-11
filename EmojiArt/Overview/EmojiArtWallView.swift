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
                    .aspectRatio(ratio, contentMode: .fit)
                    .overlay(RoundedRectangle(cornerRadius: corner).stroke(.black, lineWidth: lineWidth))
                    .opacity(document.opacityImage)
            } else {
                Image("Placeholder_ArtWall")
                    .resizable()
                    .aspectRatio(ratio, contentMode: .fit)
                    .overlay(RoundedRectangle(cornerRadius: corner).stroke(.black, lineWidth: lineWidth))
            }
            Text(documentName).font(customFont)
        }
    }
}


// MARK: - Drawing constants

private let columnSize: CGFloat = 50
private let ratio: CGFloat = 1
private let corner: CGFloat = 4
private let lineWidth: CGFloat = 2
