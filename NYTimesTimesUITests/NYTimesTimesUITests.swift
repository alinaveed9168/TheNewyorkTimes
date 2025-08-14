//
//  NYTimesTimesUITests.swift
//  NYTimesTimesUITests
//
//  Created by ali naveed on 12/08/2025.
//

import XCTest

final class NYTimesTimesUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    func testListLoadsFromStubAndOpensDetail() {
        let app = XCUIApplication()
        app.launchEnvironment["UITest_useStubData"] = "1"
        app.launch()

        // Row: prefer the identifier we set on the NavigationLink
        let rowById = app.buttons["ArticleRow_1"]
        let rowByTitle = app.staticTexts["VIPER Article One"]
        XCTAssertTrue(rowById.waitForExistence(timeout: 5.0) || rowByTitle.waitForExistence(timeout: 5.0),
                      "Expected the first article row to appear")

        if rowById.exists { rowById.tap() } else { rowByTitle.tap() }

        // Detail screen: find the element by IDENTIFIER across any element type
        let open = app.descendants(matching: .any)
            .matching(identifier: "OpenInBrowserLink")
            .firstMatch

        XCTAssertTrue(open.waitForExistence(timeout: 3.0),
                      "Expected 'OpenInBrowserLink' to exist on detail screen")

    }
}
