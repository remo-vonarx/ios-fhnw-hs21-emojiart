import SwiftUI

struct EditableText: View {
    var text: String = ""
    var isEditing: Bool
    var onChanged: (String) -> Void

    @State private var editableText: String = ""

    @Environment(\.font) private var customFont: Font?

    init(_ text: String, isEditing: Bool, onChanged: @escaping (String) -> Void) {
        self.text = text
        self.isEditing = isEditing
        self.onChanged = onChanged
    }

    var body: some View {
        Group {
            if isEditing {
                TextField(text, text: $editableText).font(customFont)
                    .onChange(of: editableText) { _ in
                        onChanged(editableText)
                    }
            } else {
                Text(text).font(customFont)
            }
        }
        .onAppear { self.editableText = self.text }
    }
}
