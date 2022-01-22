import Combine
import Foundation

class EmojiArtDocumentStore: ObservableObject {
    private static let persistenceKeyPrefix = "EmojiArtDocumentStore"

    let name: String
    @Published private var documentNames = [EmojiArtDocumentViewModel: String]()

    func name(for document: EmojiArtDocumentViewModel) -> String {
        if documentNames[document] == nil {
            documentNames[document] = defaultDocumentName
        }
        return documentNames[document]!
    }

    func setName(_ name: String, for document: EmojiArtDocumentViewModel) {
        documentNames[document] = name
    }

    var documents: [EmojiArtDocumentViewModel] {
        documentNames.keys.sorted { $0.created > $1.created }
    }

    @discardableResult func addDocument(named name: String = defaultDocumentName) -> EmojiArtDocumentViewModel {
        let document = EmojiArtDocumentViewModel()
        documentNames[document] = name
        return document
    }

    func removeDocument(_ document: EmojiArtDocumentViewModel) {
        documentNames[document] = nil
    }

    private var autosave: AnyCancellable?

    /// Initializes all EmojiArtDocumentViewModels with their assigned names
    init(named name: String = "Emoji Art") {
        self.name = name
        let defaultsKey = "\(EmojiArtDocumentStore.persistenceKeyPrefix).\(name)"
        documentNames = Dictionary(fromPropertyList: UserDefaults.standard.object(forKey: defaultsKey))
        autosave = $documentNames.sink { names in
            UserDefaults.standard.set(names.asPropertyList, forKey: defaultsKey)
        }
    }
}

// MARK: - String constants

private let defaultDocumentName: String = "Untitled"

extension Dictionary where Key == EmojiArtDocumentViewModel, Value == String {
    /// Expects a property list with [EmojiArtDocumentViewModel.id: Name] as content
    /// Initialize EmojiArtDocumentViewModels based on their UUID
    init(fromPropertyList plist: Any?) {
        self.init()
        let uuidToName = plist as? [String: String] ?? [:]
        for uuid in uuidToName.keys {
            // Loads EmojiArtDocumentViewModel from UserDefaults based on its id
            self[EmojiArtDocumentViewModel(id: UUID(uuidString: uuid)!)] = uuidToName[uuid]
        }
    }

    /// Map [EmojiArtDocumentViewModel: Name] to [EmojiArtDocumentViewModel.id: Name]
    var asPropertyList: [String: String] {
        var uuidToName = [String: String]()
        for (key, value) in self {
            uuidToName[key.id.uuidString] = value
        }
        return uuidToName
    }
}
