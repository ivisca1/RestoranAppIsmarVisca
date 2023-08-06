//
//  UserLoggedInUITests.swift
//  RestoranAppIsmarViscaUITests
//
//  Created by User on 3. 8. 2023..
//

import XCTest

final class UserLoggedInUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testBasketOrder() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let basketTabBar = app.tabBars["Tab Bar"].buttons["Korpa"]
        XCTAssertTrue(basketTabBar.exists)
        basketTabBar.tap()
        
        let tablesQuery = app.scrollViews.otherElements.tables.cells
        for _ in 0..<tablesQuery.allElementsBoundByAccessibilityElement.count{
            tablesQuery.element(boundBy: 0).swipeLeft()
            tablesQuery.element(boundBy: 0).buttons["Izbaci iz korpe"].tap()
        }
        XCTAssertEqual(tablesQuery.allElementsBoundByAccessibilityElement.count, 0)
        
        let homeTabBar = app.tabBars["Tab Bar"].buttons["Home"]
        XCTAssertTrue(homeTabBar.exists)
        homeTabBar.tap()
        
        
        let scrollViewsQuery = app.scrollViews
        let collectionViewsQuery = scrollViewsQuery.children(matching: .other).element(boundBy: 0).children(matching: .other).element(boundBy: 2).collectionViews
        
        collectionViewsQuery.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.tap()
        scrollViewsQuery.otherElements/*@START_MENU_TOKEN@*/.staticTexts["Dodaj u korpu"]/*[[".buttons[\"Dodaj u korpu\"].staticTexts[\"Dodaj u korpu\"]",".staticTexts[\"Dodaj u korpu\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["RestoranAppIsmarVisca.DishDetailView"].buttons["Nazad"].tap()
        
        collectionViewsQuery.children(matching: .cell).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.tap()
        scrollViewsQuery.otherElements/*@START_MENU_TOKEN@*/.staticTexts["Dodaj u korpu"]/*[[".buttons[\"Dodaj u korpu\"].staticTexts[\"Dodaj u korpu\"]",".staticTexts[\"Dodaj u korpu\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["RestoranAppIsmarVisca.DishDetailView"].buttons["Nazad"].tap()
        
        basketTabBar.tap()
        
        let orderButton = app.buttons["Naruči"]
        XCTAssertTrue(orderButton.exists)
        orderButton.tap()
        
        let nameSurnameLabel = app.staticTexts["Ime i prezime:"]
        nameSurnameLabel.waitForExistence(timeout: 5)
        XCTAssertTrue(nameSurnameLabel.exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
