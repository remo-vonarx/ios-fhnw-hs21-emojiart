//
//  EmojiArtDocumentPreview.swift
//  EmojiArt
//
//  Created by Remo von Arx on 22.01.22.
//

import SwiftUI

struct EmojiArtDocumentPreview: View {
    @ObservedObject var document: EmojiArtDocumentViewModel
    var documentName: String
    @State private var customFont: Font?

    var body: some View {
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
            Text("Time spent: \(document.timeSpentFormatted)").font(customFont).foregroundColor(.black)
        }
    }
}

// MARK: - Drawing constants

private let ratio: CGFloat = 1
private let corner: CGFloat = 4
private let lineWidth: CGFloat = 2
