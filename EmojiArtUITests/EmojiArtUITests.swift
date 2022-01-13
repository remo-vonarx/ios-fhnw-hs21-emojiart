//
//  EmojiArtUITests.swift
//  EmojiArtUITests
//
//  Created by Oliver Gepp on 28.10.21.
//

import XCTest

class EmojiArtUITests: XCTestCase {

    override func setUpWithError() throws {
        super.setUp()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }

    func testEditDocumentTitle() throws {
        let app = XCUIApplication()
        app.launch()
        
        if app.navigationBars["Untitled"].exists {
            app.navigationBars["Untitled"]/*@START_MENU_TOKEN@*/.buttons["BackButton"]/*[[".buttons[\"Emoji Art\"]",".buttons[\"BackButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        }
        let emojiArtNavigationBar = app.navigationBars["Emoji Art"]
        emojiArtNavigationBar.buttons["Edit"].tap()
        app.tables.textFields["Untitled"].tap()
        app.tables.textFields["Untitled"].doubleTap()
//        app.keys["N"].tab()
//        app.keys["e"].tab()
//        app.keys["w"].tab()
//        app.keys[" "].tab()
//        app.keys["T"].tab()
//        app.keys["i"].tab()
//        app.keys["t"].tab()
//        app.keys["l"].tab()
//        app.keys["e"].tab()
        emojiArtNavigationBar.buttons["Done"].tap()
        app.tables.buttons["New Title"].tap()

    }

    func estLaunchPerformance() throws {
        if #available(iOS 13.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
