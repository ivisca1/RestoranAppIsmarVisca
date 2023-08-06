//
//  UserLoggedOutUITests.swift
//  RestoranAppIsmarViscaUITests
//
//  Created by User on 3. 8. 2023..
//

import XCTest

final class UserLoggedOutUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testBasket() throws {
        let app = XCUIApplication()
        app.launch()
        
        let basketTabBar = app.tabBars["Tab Bar"].buttons["Korpa"]
        XCTAssertTrue(basketTabBar.exists)
        basketTabBar.tap()
        
        let noBasketLabel = app.staticTexts["Prijavite se da biste pristupili korpi!"]
        XCTAssertTrue(noBasketLabel.exists)
    }
    
    func testReservations() throws {
        let app = XCUIApplication()
        app.launch()
        
        let reservationsTabBar = app.tabBars["Tab Bar"].buttons["Rezervacije"]
        XCTAssertTrue(reservationsTabBar.exists)
        reservationsTabBar.tap()
        
        let noReservationsLabel = app.staticTexts["Prijavite se da biste pristupili rezervacijama!"]
        XCTAssertTrue(noReservationsLabel.exists)
    }

    func testLogIn1() throws {
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
    
    func testLogIn2() throws {
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
        passwordTextField.typeText("ismar123")
        
        app.keyboards.buttons["Idi"].tap()
        
        let secondLogInButton = app.buttons["Log In"]
        XCTAssertTrue(secondLogInButton.exists)
        
        let wrongPasswordLabel = app.staticTexts["Šifra neispravna!"]
        wrongPasswordLabel.waitForExistence(timeout: 2)
        XCTAssertTrue(wrongPasswordLabel.exists)
    }
    
    func testSignUp1() throws {
        let app = XCUIApplication()
        app.launch()
        
        let profileTabBar = app.tabBars["Tab Bar"].buttons["Profil"]
        XCTAssertTrue(profileTabBar.exists)
        profileTabBar.tap()
        
        let logInButton = app.buttons["Sign Up"]
        XCTAssertTrue(logInButton.exists)
        logInButton.tap()
        
        let nameTextField = app.textFields["Ime"]
        XCTAssertTrue(nameTextField.exists)
        nameTextField.tap()
        nameTextField.typeText("Test")
        
        app.keyboards.buttons["Sljedeće"].tap()
        
        let surnameTextField = app.textFields["Prezime"]
        XCTAssertTrue(surnameTextField.exists)
        surnameTextField.typeText("Test")
        
        app.keyboards.buttons["Sljedeće"].tap()
        
        let phoneNumberTextfield = app.textFields["Broj Telefona"]
        XCTAssertTrue(phoneNumberTextfield.exists)
        phoneNumberTextfield.typeText("38761999999")
        
        app.keyboards.buttons["Sljedeće"].tap()
        
        let emailTextField = app.textFields["Email"]
        XCTAssertTrue(emailTextField.exists)
        emailTextField.typeText("test@gmail.com")
        
        app.keyboards.buttons["Sljedeće"].tap()
        
        let addressTextField = app.textFields["Adresa"]
        XCTAssertTrue(addressTextField.exists)
        addressTextField.typeText("Test")
        
        app.keyboards.buttons["Sljedeće"].tap()
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.typeText("issmar123")
        
        app.keyboards.buttons["Sljedeće"].tap()
        
        let passwordAgainTextField = app.secureTextFields["Potvrdi password"]
        XCTAssertTrue(passwordAgainTextField.exists)
        passwordAgainTextField.typeText("issmar123")
        
        app.keyboards.buttons["Idi"].tap()
        
        let secondLogInButton = app.buttons["Sign Up"]
        XCTAssertTrue(secondLogInButton.exists)
        
        let nameSurnameLabel = app.scrollViews.otherElements.staticTexts["Test Test"]
        nameSurnameLabel.waitForExistence(timeout: 5)
        XCTAssertTrue(nameSurnameLabel.exists)
    }
    
    func testSignUp2() throws {
        let app = XCUIApplication()
        app.launch()
        
        let profileTabBar = app.tabBars["Tab Bar"].buttons["Profil"]
        XCTAssertTrue(profileTabBar.exists)
        profileTabBar.tap()
        
        let logInButton = app.buttons["Sign Up"]
        XCTAssertTrue(logInButton.exists)
        logInButton.tap()
        
        let nameTextField = app.textFields["Ime"]
        XCTAssertTrue(nameTextField.exists)
        nameTextField.tap()
        nameTextField.typeText("Test")
        
        app.keyboards.buttons["Sljedeće"].tap()
        
        let surnameTextField = app.textFields["Prezime"]
        XCTAssertTrue(surnameTextField.exists)
        surnameTextField.typeText("Test")
        
        app.keyboards.buttons["Sljedeće"].tap()
        
        let phoneNumberTextfield = app.textFields["Broj Telefona"]
        XCTAssertTrue(phoneNumberTextfield.exists)
        phoneNumberTextfield.typeText("38761999999")
        
        app.keyboards.buttons["Sljedeće"].tap()
        
        let emailTextField = app.textFields["Email"]
        XCTAssertTrue(emailTextField.exists)
        emailTextField.typeText("ivisca1@etf.unsa.ba")
        
        app.keyboards.buttons["Sljedeće"].tap()
        
        let addressTextField = app.textFields["Adresa"]
        XCTAssertTrue(addressTextField.exists)
        addressTextField.typeText("Test")
        
        app.keyboards.buttons["Sljedeće"].tap()
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.typeText("issmar123")
        
        app.keyboards.buttons["Sljedeće"].tap()
        
        let passwordAgainTextField = app.secureTextFields["Potvrdi password"]
        XCTAssertTrue(passwordAgainTextField.exists)
        passwordAgainTextField.typeText("issmar123")
        
        app.keyboards.buttons["Idi"].tap()
        
        let secondLogInButton = app.buttons["Sign Up"]
        XCTAssertTrue(secondLogInButton.exists)
        
        let emailAlreadyInUseLabel = app.staticTexts["Profil sa ovim email-om već postoji!"]
        emailAlreadyInUseLabel.waitForExistence(timeout: 2)
        XCTAssertTrue(emailAlreadyInUseLabel.exists)
    }
    
    func testForgotPassword() throws {
        let app = XCUIApplication()
        app.launch()
        
        let profileTabBar = app.tabBars["Tab Bar"].buttons["Profil"]
        XCTAssertTrue(profileTabBar.exists)
        profileTabBar.tap()
        
        let logInButton = app.buttons["Log In"]
        XCTAssertTrue(logInButton.exists)
        logInButton.tap()
        
        let forgotPasswordButton = app.buttons["Zaboravili ste šifru?"]
        XCTAssertTrue(forgotPasswordButton.exists)
        forgotPasswordButton.tap()
        
        let emailTextField = app.textFields["Email"]
        XCTAssertTrue(emailTextField.exists)
        emailTextField.tap()
        emailTextField.typeText("ivisca1@etf.unsa.ba")
        
        let sendButton = app.buttons["Pošalji"]
        XCTAssertTrue(sendButton.exists)
        sendButton.tap()
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
