//
//  EmojiArtWallView.swift
//  EmojiArt
//
//  Created by Remo von Arx on 02.12.21.
//

import SwiftUI

struct EmojiArtWallView: View {
    
    var documents: [EmojiArtDocumentViewModel]
    
    
    init(documents: [EmojiArtDocumentViewModel]) {
        self.documents = documents
    }
    
    let rows = [
        GridItem(.fixed(33)),
        GridItem(.fixed(33)),
        GridItem(.fixed(33)),

    ]
    
    // MARK: - Zooming
    @State private var steadyZoomScale: CGFloat = 0.3
    @GestureState private var gestureZoomScale: CGFloat = 0.3
    private var zoomScale: CGFloat {
        steadyZoomScale * gestureZoomScale
    }
    
    var body: some View {
        ScrollView {
            LazyHGrid(rows: rows, alignment: .center){
                ForEach(documents, id: \.self) { item in
                    if let image = item.backgroundImage {
                        Image(uiImage: image)
                            .scaleEffect(zoomScale)
                        Text(item.id.uuidString)
                    } else{
                        Text("No background image")
                    }
                }
            }
        }
    }
}
