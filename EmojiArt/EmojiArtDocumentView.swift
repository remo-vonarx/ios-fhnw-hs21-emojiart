import SwiftUI

struct EmojiArtDocumentView: View {
    
    @ObservedObject var document: EmojiArtDocumentViewModel
    
    var body: some View {
        VStack {
            createPalette()
            GeometryReader { geometry in
                ZStack{
                    createBackground(geometry: geometry)
                    createEmojiLayer(geometry: geometry)
                }
                .gesture(doubleTapGesture(in: geometry))
            }
            .gesture(panGesture())
            .gesture(zoomGesture())
            .clipped()
        }
    }
    
    private func createPalette() -> some View {
        return ScrollView(.horizontal) {
            HStack{
                ForEach(EmojiArtDocumentViewModel.palette.map{String($0)},id: \.self) { emoji in
                    Text(emoji)
                        .font(Font.system(size: defaultEmojiSize))
                        .onDrag { NSItemProvider(object: emoji as NSString) }
                }
            }
        }.padding(.horizontal)
    }
    
    private func createBackground(geometry: GeometryProxy) -> some View {
        return Color.white.overlay(
            Group {
                if let image =  document.backgroundImage {
                    Image(uiImage: image)
                        .scaleEffect(zoomScale)
                        .position(toCanvasCoordinate(from: CGPoint(x: 0, y: 0), in: geometry))
                }
            }
        )
            .edgesIgnoringSafeArea([.horizontal,.bottom])
            .onDrop(of: [.url, .plainText, .image], isTargeted: nil) { providers, location in
                return drop(providers: providers, location: location, geometry: geometry)
            }
    }
    
    private func createEmojiLayer(geometry: GeometryProxy) -> some View {
        Group {
            ForEach(document.emojis) { emoji in
                Text(emoji.text)
                    .font(font(for: emoji))
                    .position(toCanvasCoordinate(from: emoji.location, in: geometry))
            }
        }
    }
    
    private func drop(providers: [NSItemProvider], location: CGPoint, geometry: GeometryProxy) -> Bool {
        var isDropHandled = providers.loadObjects(ofType: URL.self) { url in
            document.setBackgroundURL(url)
        }
        if !isDropHandled {
            isDropHandled = providers.loadObjects(ofType: String.self, using: { string in
                let emojiLocation = toEmojiCoordinate(from: location, in: geometry)
                document.addEmoji(string, at: emojiLocation, size: defaultEmojiSize)
            })
        }
        return isDropHandled
    }
    
    private func font(for emoji: EmojiArtModel.Emoji) -> Font {
        let fontSize = emoji.fontSize * zoomScale
        return Font.system(size: fontSize)

    }

    // MARK: - Panning
    @State private var steadyPanOffset: CGSize = .zero
    @GestureState private var gesturePanOffset: CGSize = .zero
    private var panOffset: CGSize {
        steadyPanOffset + gesturePanOffset
    }

    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset, body: { latestDragGestureValue, gesturePanOffset, _ in
                gesturePanOffset = latestDragGestureValue.translation
            })
            .onEnded { finalDragGestureValue in
                steadyPanOffset = panOffset + finalDragGestureValue.translation
            }
    }

    // MARK: - Zooming
    @State private var steadyZoomScale: CGFloat = 1.0
    @GestureState private var gestureZoomScale: CGFloat = 1.0
    private var zoomScale: CGFloat {
        steadyZoomScale * gestureZoomScale
    }

    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale, body: { magnifyBy, gestureZoomScale, _ in
                gestureZoomScale = magnifyBy
            })
            .onEnded { finalDragGestureValue in
                steadyZoomScale *= finalDragGestureValue
            }
    }

    private func doubleTapGesture(in geometry: GeometryProxy) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                if let image = document.backgroundImage {
                    let horizontalZoom = geometry.size.width / image.size.width
                    let verticalZoom = geometry.size.height / image.size.height
                    steadyPanOffset = .zero
                    steadyZoomScale = min(horizontalZoom, verticalZoom)
                }
            }
    }

    // MARK: - Positioning & Sizing Emojis
    private func toCanvasCoordinate(from emojiCoordinate: CGPoint, in geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(
            x: center.x + emojiCoordinate.x * zoomScale + panOffset.width,
            y: center.y + emojiCoordinate.y * zoomScale + panOffset.height
        )
    }

    private func toEmojiCoordinate(from canvasCoordinate: CGPoint, in geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(
            x: (canvasCoordinate.x - center.x - panOffset.width) / zoomScale,
            y: (canvasCoordinate.y - center.y - panOffset.height) / zoomScale
        )
    }
    
    // MARK: - Drawing constants
    private let defaultEmojiSize: CGFloat = 40
}
