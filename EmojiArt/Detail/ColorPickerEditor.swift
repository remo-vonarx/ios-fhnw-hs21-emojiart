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
    @State var opacityColor: Double
    @State var opacityImage: Double

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
                ColorPicker("Background color", selection: $backgroundColor)
                    .onChange(of: backgroundColor) { newValue in
                        document.backgroundColor = newValue
                    }
                HStack {
                    Text("Opacity of background color")
                    Spacer()
                    Slider(value: $opacityColor)
                        .onChange(of: opacityColor) { newValue in
                            document.opacityColor = newValue
                        }
                }
                HStack {
                    Text("Opacity of background image")
                    Spacer()
                    Slider(value: $opacityImage)
                        .onChange(of: opacityImage) { newValue in
                            document.opacityImage = newValue
                        }
                }
            }
        }
    }
}
