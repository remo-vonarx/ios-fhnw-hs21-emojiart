//
//  Font.swift
//  EmojiArt
//
//  Created by Remo von Arx on 24.12.21.
//

import Foundation
import SwiftUI

public extension Font {
  init(uiFont: UIFont) {
    self = Font(uiFont as CTFont)
  }
}
