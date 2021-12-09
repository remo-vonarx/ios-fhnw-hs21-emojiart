import Combine
import SwiftUI

class EmojiArtDocumentViewModel: ObservableObject, Equatable, Hashable, Identifiable {
    static func == (lhs: EmojiArtDocumentViewModel, rhs: EmojiArtDocumentViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher){
        hasher.combine(id)
    }
    
    let id: UUID
    
    static let palette: String = "🐶🐱🐹🐰🦊🐼🐨🐯🐸🐵🐧🐦🐤🦆🦅🦇🐺"
    
    @Published private var emojiArtModel: EmojiArtModel
    var emojiartModelSink: AnyCancellable?
    
    @Published private(set) var backgroundImage: UIImage?
    var emojis: [EmojiArtModel.Emoji] { emojiArtModel.emojis }
    
    // TODO: Timer schould be in Model if possible
    @Published var timeSpent: Int = 0
    @Published private var timer: Publishers.Autoconnect<Timer.TimerPublisher>? = nil
    private var subscription: AnyCancellable? = nil
    
    var backgroundURL: URL? {
        get {
            emojiArtModel.backgroundURL
        }
        set {
            emojiArtModel.backgroundURL = newValue?.imageURL
            fetchBackgroundImageData()
        }
    }
    
    
    init(id:UUID = UUID()) {
        self.id = id
        let emojiArtDocumentKey = "EmojiArtDocumentViewModel.Untitled\(id)"
        let emojiArtJson = UserDefaults.standard.data(forKey: emojiArtDocumentKey)
        emojiArtModel = EmojiArtModel(json: emojiArtJson) ?? EmojiArtModel()
        emojiartModelSink = $emojiArtModel.sink { emojiArtModel in
            print("JSON: \(emojiArtModel.json?.utf8 ?? "nil")")
            UserDefaults.standard.set(emojiArtModel.json, forKey: emojiArtDocumentKey)
        }
        fetchBackgroundImageData()
    }
    
    
    func startTimeTracker(){
        timeSpent = UserDefaults.standard.integer(forKey: "EmojiArtDocumentViewModel.\(id).timeSpent")
        print("Starting/Resuming timer at \(timeSpent) s")
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        subscription = timer?.sink(receiveValue: { _ in
            self.updateTimeSpent()
        })
    }
    
    func stopTimeTracker(){
        print("Stopping timer at \(timeSpent) s")
        UserDefaults.standard.set(timeSpent, forKey: "EmojiArtDocumentViewModel.\(id).timeSpent")
        self.timer?.upstream.connect().cancel()
    }
    
    func updateTimeSpent(){
        timeSpent += 1
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
