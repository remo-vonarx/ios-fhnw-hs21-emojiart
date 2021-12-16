import Combine
import SwiftUI

class EmojiArtDocumentViewModel: ObservableObject, Equatable, Hashable, Identifiable {
    static func == (lhs: EmojiArtDocumentViewModel, rhs: EmojiArtDocumentViewModel) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    let id: UUID

    static let palette: String = "🐶🐱🐹🐰🦊🐼🐨🐯🐸🐵🐧🐦🐤🦆🦅🦇🐺"

    @Published private var emojiArtModel: EmojiArtModel
    var emojiartModelSink: AnyCancellable?

    @Published private(set) var backgroundImage: UIImage?
    var emojis: [EmojiArtModel.Emoji] { emojiArtModel.emojis }

    // TODO: timer not stopping while app inactive or closed
    // TODO: when more than 1 project -> problem with counting sometimes
    private var timer: Publishers.Autoconnect<Timer.TimerPublisher>?
    private var subscription: AnyCancellable?

    var backgroundColor: Color {
        get {
            return Color(UIColor(red: CGFloat(emojiArtModel.backgroundColor.red), green: CGFloat(emojiArtModel.backgroundColor.green), blue: CGFloat(emojiArtModel.backgroundColor.blue), alpha: CGFloat(emojiArtModel.backgroundColor.alpha)))
        }
        set {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            UIColor(newValue).getRed(&red, green: &green, blue: &blue, alpha: &alpha)

            emojiArtModel.backgroundColor.red = Float(red)
            emojiArtModel.backgroundColor.green = Float(green)
            emojiArtModel.backgroundColor.blue = Float(blue)
            emojiArtModel.backgroundColor.alpha = Float(alpha)
        }
    }

    var opacity: Double {
        get {
            emojiArtModel.opacity
        }
        set {
            emojiArtModel.opacity = newValue
        }
    }

    var backgroundURL: URL? {
        get {
            emojiArtModel.backgroundURL
        }
        set {
            emojiArtModel.backgroundURL = newValue?.imageURL
            fetchBackgroundImageData()
        }
    }

    init(id: UUID = UUID()) {
        self.id = id
        let emojiArtDocumentKey = "EmojiArtDocumentViewModel.Untitled\(id)"
        let emojiArtJson = UserDefaults.standard.data(forKey: emojiArtDocumentKey)
        emojiArtModel = EmojiArtModel(json: emojiArtJson) ?? EmojiArtModel()
        emojiartModelSink = $emojiArtModel.sink { emojiArtModel in
            // print("JSON: \(emojiArtModel.json?.utf8 ?? "nil")")
            UserDefaults.standard.set(emojiArtModel.json, forKey: emojiArtDocumentKey)
        }
        fetchBackgroundImageData()
    }

    func startTimeTracker() {
        print("Starting/Resuming timer at \(emojiArtModel.timeSpent) s")
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        subscription = timer?.sink(receiveValue: { _ in
            self.updateTimeSpent()
        })
    }

    func stopTimeTracker() {
        print("Stopping timer at \(emojiArtModel.timeSpent) s")
        subscription?.cancel()
        timer?.upstream.connect().cancel()
    }

    func getTime() -> Int {
        emojiArtModel.timeSpent
    }

    func updateTimeSpent() {
        emojiArtModel.timeSpent += 1
        print("---> \(emojiArtModel.timeSpent) s")
        UserDefaults.standard.set(emojiArtModel.timeSpent, forKey: "EmojiArtDocumentViewModel.\(id).timeSpent")
    }

    // MARK: - Intents

    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArtModel.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }

    private var fetchImageSink: AnyCancellable?
    private func fetchBackgroundImageData() {
        fetchImageSink?.cancel()
        backgroundImage = nil
        if let url = emojiArtModel.backgroundURL {
            fetchImageSink = URLSession.shared.dataTaskPublisher(for: url)
                .map { data, _ in UIImage(data: data) }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
                .sink { fetchedImage in
                    self.backgroundImage = fetchedImage
                }
        }
    }
}

extension EmojiArtModel.Emoji {
    var fontSize: CGFloat { CGFloat(size) }
    var location: CGPoint { CGPoint(x: x, y: y) }
}
