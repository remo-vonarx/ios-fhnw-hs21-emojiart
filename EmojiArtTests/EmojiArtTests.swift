//
//  EmojiArtTests.swift
//  EmojiArtTests
//
//  Created by Oliver Gepp on 28.10.21.
//

import XCTest
@testable import EmojiArt

class EmojiArtTests: XCTestCase {
    var document: EmojiArtDocumentViewModel!

    override func setUpWithError() throws {
        super.setUp()
        document = EmojiArtDocumentViewModel()
    }

    override func tearDownWithError() throws {
        document = nil
        super.tearDown()
    }

    func testAddEmoji_whenTextIsEmpty_doesNothing() throws {
        let paletteCount = document.paletteNames.count
        let palette = document.defaultPalette
        
        document.addEmoji("", toPalette: palette)
        
        XCTAssertEqual(paletteCount, document.paletteNames.count)
        XCTAssertEqual(palette, document.defaultPalette)

        document.addEmoji(" ", toPalette: palette)
        
        XCTAssertEqual(paletteCount, document.paletteNames.count)
        XCTAssertEqual(palette, document.defaultPalette)
    }
    
    func testAddEmoji_whenTextIsEmoji() throws {
        let paletteCount = document.paletteNames.count
        let palette = document.defaultPalette
        let emoji = "🙃"
        
        document.addEmoji(emoji, toPalette: palette)
        
        XCTAssertEqual(paletteCount, document.paletteNames.count)
        XCTAssertTrue(document.defaultPalette.contains(palette))
        XCTAssertTrue(document.defaultPalette.contains(emoji))
    }
    
    func testRemoveEmoji_whenTextIsEmoji() throws {
        let paletteCount = document.paletteNames.count
        let palette = document.defaultPalette
        let emoji = document.defaultPalette.first!.description
        
        document.removeEmojis(emoji, fromPalette: palette)
        
        XCTAssertEqual(paletteCount, document.paletteNames.count)
        XCTAssertEqual(palette,emoji + document.defaultPalette)
        XCTAssertFalse(document.defaultPalette.contains(emoji))
    }
    
    func testRemoveEmoji_whenTextNotExisting_doesNothing() throws {
        let paletteCount = document.paletteNames.count
        let palette = document.defaultPalette
        let emoji = "A"

        XCTAssertFalse(document.defaultPalette.contains(emoji))

        document.removeEmojis(emoji, fromPalette: palette)
        
        XCTAssertEqual(paletteCount, document.paletteNames.count)
        XCTAssertEqual(palette, document.defaultPalette)
    }
    
    func testRemoveEmoji_whenTextIsEmpty_doesNothing() throws {
        let paletteCount = document.paletteNames.count
        let palette = document.defaultPalette
        
        document.removeEmojis("", fromPalette: palette)
        
        XCTAssertEqual(paletteCount, document.paletteNames.count)
        XCTAssertEqual(palette, document.defaultPalette)

        document.removeEmojis(" ", fromPalette: palette)
        
        XCTAssertEqual(paletteCount, document.paletteNames.count)
        XCTAssertEqual(palette, document.defaultPalette)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
