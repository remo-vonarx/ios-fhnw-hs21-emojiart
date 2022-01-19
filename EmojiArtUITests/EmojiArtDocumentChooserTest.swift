//
//  EmojiArtUITests.swift
//  EmojiArtUITests
//
//  Created by Oliver Gepp on 28.10.21.
//

import XCTest

class EmojiArtUITests: XCTestCase {
    private let app = XCUIApplication()
    
    var is_iPad: Bool {
       return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    override func setUpWithError() throws {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        
        //This is called before all the test methods are being called
    }
    
    override func tearDownWithError() throws {
        super.tearDown()
        
        //This is called after all the test methods got called
    }
    
    fileprivate func setUpAppForDevice() {
        //define some test input, also to satisfy some Grenzwerte
        //Check if the device is an iPad.
        if(is_iPad){
            //If the DocumentChooser Button is visible, tap on it to reach the DocumentChooser.
            let documentChooserButton = app.buttons["Emoji Art"]
            if(documentChooserButton.exists){
                documentChooserButton.tap()
            }
        }
    }
    
    func testEditDocumentTitles() throws{
        let titles:[String] = ["EmojiArt", "My first EmojiArt", "🙃", "", " "]
        setUpAppForDevice()
        for title in titles {
            try editDocumentTitle(title: title)
        }
    }

    func editDocumentTitle(title: String) throws {
        //Check if there are some documents
        let cells = app.tables.cells.count
        XCTAssertTrue(cells > 0)
        
        //Get the first document because it's always be there by default.
        let firstDocument = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(firstDocument.exists)
        
        //Fetch the name by the document label so it can be used later.
        let firstDocumentName = firstDocument.label
        
        //Fetch the navigation bar and tap "Edit"
        let emojiArtNavigationBar = app.navigationBars["Emoji Art"]
        XCTAssertTrue(emojiArtNavigationBar.exists)
        emojiArtNavigationBar.buttons["Edit"].tap()
        
        //Tap into the first document to get let EditableText appear as a TextField.
        firstDocument.tap()
        
        //Fetch for the first textField (there should only be one).
        let documentTitleTextField = app.textFields.firstMatch
        XCTAssertTrue(documentTitleTextField.exists)
        
        //First clear the current title by pressing delete the amount of initial documentName.
        let deleteInput = String(repeating: XCUIKeyboardKey.delete.rawValue, count: firstDocumentName.count)
        documentTitleTextField.typeText(deleteInput)
        
        //Check if the deletion succeeded by checking the size
        let currentDocumentTitle = documentTitleTextField.value as! String
        XCTAssertTrue(currentDocumentTitle.count == 0)
        
        //Now type the new document title and press "Done".
        documentTitleTextField.typeText(title)
        emojiArtNavigationBar.buttons["Done"].tap()
        
        let updatedDocumentName = firstDocument.label
        
        XCTAssertTrue(app.tables.buttons[title].firstMatch.exists)
        XCTAssertEqual(updatedDocumentName.count, title.count)
        XCTAssertEqual(updatedDocumentName, title)
    }
}
