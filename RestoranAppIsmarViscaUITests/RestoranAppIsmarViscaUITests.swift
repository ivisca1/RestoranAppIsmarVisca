//
//  RestoranAppIsmarViscaUITests.swift
//  RestoranAppIsmarViscaUITests
//
//  Created by User on 2. 8. 2023..
//

import XCTest

final class RestoranAppIsmarViscaUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let profileTabBar = app.tabBars["Tab Bar"].buttons["Profil"]
        XCTAssertTrue(profileTabBar.exists)
        profileTabBar.tap()
        
        let logInButton = app.buttons["Log In"]
        XCTAssertTrue(logInButton.exists)
        logInButton.tap()
        
        let emailTextField = app.textFields["Email"]
        XCTAssertTrue(emailTextField.exists)
        emailTextField.tap()
        emailTextField.typeText("ivisca1@etf.unsa.ba")
        
        app.keyboards.buttons["Sljedeće"].tap()
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.typeText("issmar123")
        
        app.keyboards.buttons["Idi"].tap()
        
        let secondLogInButton = app.buttons["Log In"]
        XCTAssertTrue(secondLogInButton.exists)
        
        let nameSurnameLabel = app.scrollViews.otherElements.staticTexts["Ismar Višća"]
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
