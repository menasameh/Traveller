//
//  TravellerUITests.swift
//  TravellerUITests
//
//  Created by Mina Sameh on 30/3/21.
//

import XCTest

class TravellerUITests: XCTestCase {
    func testPopularFlightsFlow() {
        let app = XCUIApplication()
        app.launch()

        app.buttons["popularFlights"].tap()
        
        if app.tables.children(matching: .cell).firstMatch.waitForExistence(timeout: 5) {
            XCTAssert(app.tables.children(matching: .cell).count == 5)
        } else {
            XCTFail()
        }
    }
}
