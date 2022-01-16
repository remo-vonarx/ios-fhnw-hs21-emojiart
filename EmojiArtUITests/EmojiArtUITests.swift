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
        
        // go to overview if in detail view
        if app.navigationBars.firstMatch/*@START_MENU_TOKEN@*/.buttons["BackButton"]/*[[".buttons[\"Emoji Art\"]",".buttons[\"BackButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists {
            app.navigationBars.firstMatch/*@START_MENU_TOKEN@*/.buttons["BackButton"]/*[[".buttons[\"Emoji Art\"]",".buttons[\"BackButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        }

        // delete all files until no new name file is left
        let emojiArtNavigationBar = app.navigationBars["Emoji Art"]
        if app.tables.buttons["New Title"].firstMatch.exists {
            emojiArtNavigationBar.buttons["Edit"].tap()
            
            while app.tables.textFields["New Title"].firstMatch.exists {
                let tablesQuery = app.tables
                tablesQuery/*@START_MENU_TOKEN@*/.buttons["Delete "]/*[[".cells.buttons[\"Delete \"]",".buttons[\"Delete \"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
                tablesQuery/*@START_MENU_TOKEN@*/.buttons["Delete"]/*[[".cells.buttons[\"Delete\"]",".buttons[\"Delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
            }
            emojiArtNavigationBar.buttons["Done"].tap()
        }
        
        XCTAssertFalse(app.tables.buttons["New Title"].exists)

        // add untitled if not existing
        if !app.tables.buttons["Untitled"].exists {
            emojiArtNavigationBar.buttons["Add"].tap()
        }

        // enter untitiled edit mode
        emojiArtNavigationBar.buttons["Edit"].tap()
        let untitledTextField = app.tables/*@START_MENU_TOKEN@*/.textFields["Untitled"]/*[[".cells",".buttons.textFields[\"Untitled\"]",".textFields[\"Untitled\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch
        untitledTextField.tap()
        untitledTextField.doubleTap()

        // add new text
        writeNewTitle(app: app)
                
        emojiArtNavigationBar.buttons["Done"].tap()

        // test changes existing
        XCTAssertTrue(app.tables.buttons["New Title"].firstMatch.exists)
    }
    
    func writeNewTitle(app: XCUIApplication) {
        let nKey = app/*@START_MENU_TOKEN@*/.keys["N"]/*[[".keyboards.keys[\"N\"]",".keys[\"N\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        nKey.tap()
        
        let eKey = app/*@START_MENU_TOKEN@*/.keys["e"]/*[[".keyboards.keys[\"e\"]",".keys[\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        eKey.tap()
        
        let wKey = app/*@START_MENU_TOKEN@*/.keys["w"]/*[[".keyboards.keys[\"w\"]",".keys[\"w\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        wKey.tap()
        
        var leerzeichenKey = app/*@START_MENU_TOKEN@*/.keys["Leerzeichen"]/*[[".keyboards.keys[\"Leerzeichen\"]",".keys[\"Leerzeichen\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        if !leerzeichenKey.exists {
            leerzeichenKey = app/*@START_MENU_TOKEN@*/.keys["space"]/*[[".keyboards.keys[\"space\"]",".keys[\"space\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        }
        leerzeichenKey.tap()
        
        app/*@START_MENU_TOKEN@*/.buttons["shift"]/*[[".keyboards",".buttons[\"Umschalt\"]",".buttons[\"shift\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        let tKey = app/*@START_MENU_TOKEN@*/.keys["T"]/*[[".keyboards.keys[\"T\"]",".keys[\"T\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        tKey.tap()
        
        let iKey = app/*@START_MENU_TOKEN@*/.keys["i"]/*[[".keyboards.keys[\"i\"]",".keys[\"i\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        iKey.tap()
        
        let tKey2 = app/*@START_MENU_TOKEN@*/.keys["t"]/*[[".keyboards.keys[\"t\"]",".keys[\"t\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        tKey2.tap()
        
        let lKey = app/*@START_MENU_TOKEN@*/.keys["l"]/*[[".keyboards.keys[\"l\"]",".keys[\"l\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        lKey.tap()
        
        eKey.tap()
    }

    func testLaunchPerformance() throws {
        if #available(iOS 13.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
