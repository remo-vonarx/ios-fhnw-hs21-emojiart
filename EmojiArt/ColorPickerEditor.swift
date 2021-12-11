//
//  ColorPicker.swift
//  EmojiArt
//
//  Created by Ramona Marti on 11.12.21.
//

import SwiftUI

struct ColorPickerEditor: View {
    @ObservedObject var document: EmojiArtDocumentViewModel
    @State var backgroundColor: Color
    @State var opacity: Double

    @Environment(\.presentationMode) var presentation

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Background Color Editor")
                    .font(.headline)
                    .padding()
                Spacer()
                Button(action: {
                    self.presentation.wrappedValue.dismiss()
                }) {
                    Text("Done")
                }.padding()
            }
            Form {
                ColorPicker("Backgroundcolor", selection: $backgroundColor)
                    .onChange(of: backgroundColor) { newValue in
                        document.backgroundColor = newValue
                    }
                HStack {
                    Text("Opacity of background")
                    Spacer()
                    Slider(value: $opacity)
                        .onChange(of: opacity) { newValue in
                            document.opacity = newValue
                        }
                }
            }
        }
    }
}
