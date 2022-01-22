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
                    // in case the opacity is below minOpacity, set it to minOpacity - otherwise the image would not be visible
                    .opacity(document.opacityImage > minOpacity ? document.opacityImage : minOpacity)

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
private let minOpacity: CGFloat = 0.2
