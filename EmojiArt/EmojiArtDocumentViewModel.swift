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

    private static let emojiArtDocumentKey = "EmojiArtDocumentViewModel.Untitled"

    @Published private var emojiArtModel: EmojiArtModel
    var emojiartModelSink: AnyCancellable?
    
    @Published private(set) var backgroundImage: UIImage?
    @Published var timeSpentInSeconds: Int

    private var timer: Publishers.Autoconnect<Timer.TimerPublisher>? = nil
    private var subscription: AnyCancellable? = nil

    var emojis: [EmojiArtModel.Emoji] { emojiArtModel.emojis }

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

    var emojiartModelSink: AnyCancellable?
    init() {
        let emojiArtJson = UserDefaults.standard.data(forKey: EmojiArtDocumentViewModel.emojiArtDocumentKey)
        emojiArtModel = EmojiArtModel(json: emojiArtJson) ?? EmojiArtModel()
        emojiartModelSink = $emojiArtModel.sink { emojiArtModel in
            print("JSON: \(emojiArtModel.json?.utf8 ?? "nil")")
            UserDefaults.standard.set(emojiArtModel.json, forKey: emojiArtDocumentKey)
        }
        fetchBackgroundImageData()
    }

    // MARK: - Intents
    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArtModel.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    func startTimeTracker(){
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        subscription = timer?.sink(receiveValue: { _ in
           self.updateTimeSpent()
        })
    }
    
    func updateTimeSpent(){
        timeSpentInSeconds += 1
    }
    
    func saveTimeSpent(){
        UserDefaults.standard.set(timeSpentInSeconds, forKey: EmojiArtDocumentViewModel.timeSpentInSecondsKey)
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
