import Foundation

struct EmojiArtModel: Codable {
    var backgroundURL: URL?
    var backgroundColor = ColorRgbModel(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    var opacityImage: Double = 1
    var timeSpent: Int = 0
    var emojis = [Emoji]()
    var created = Date().timeIntervalSince1970

    init() {}

    init?(json: Data?) {
        if let json = json, let newEmojiArt = try? JSONDecoder().decode(EmojiArtModel.self, from: json) {
            self = newEmojiArt // structs can be assigned in their init
        } else {
            return nil
        }
    }

    struct Emoji: Identifiable, Codable {
        let text: String
        var x: Int // offset from center
        var y: Int // offset from center
        var size: Int
        let id: Int

        fileprivate init(text: String, x: Int, y: Int, size: Int, id: Int) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }

    var json: Data? {
        return try? JSONEncoder().encode(self)
    }

    private var uniqueEmojiId = 0

    mutating func addEmoji(_ text: String, x: Int, y: Int, size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(text: text, x: x, y: y, size: size, id: uniqueEmojiId))
    }
}
