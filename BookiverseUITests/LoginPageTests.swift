//
//  LoginPageTests
//  BookiverseUITests
//
//  Created by Obed Martinez on 21/12/23
//



import XCTest

final class LoginPageTests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func testLoginWithEmailAndPassword() {
        let emailTextField = app.textFields["emailTxt"]
        XCTAssertTrue(emailTextField.exists)
        emailTextField.tap()
        emailTextField.typeText("example@email.com")
        
        
//                let passwordTextField = app.textFields["passwordTxt"]
//                XCTAssertTrue(passwordTextField.exists)
//                passwordTextField.tap()
//                passwordTextField.typeText("password123")
        
        let loginButton = app.buttons["loginBtn"]
        XCTAssertTrue(loginButton.exists)
        loginButton.tap()
        
    }
    
    func testRegisterButton() {
        let registerButton = app.buttons["registrateBtn"]
        XCTAssertTrue(registerButton.exists)
        
        registerButton.tap()
        
        let registerPageLabel = app.staticTexts["Crear cuenta"]
        XCTAssertTrue(registerPageLabel.waitForExistence(timeout: 5))
    }
    
    func testAnonymousLoginButton() {
        let anonymousLoginButton = app.buttons["anonymBtn"]
        XCTAssertTrue(anonymousLoginButton.exists)
        
        anonymousLoginButton.tap()
        
        let homePageLabel = app.staticTexts["Busqueda de libros"]
        XCTAssertTrue(homePageLabel.waitForExistence(timeout: 5))
    }
    
    func testFaceIdButton() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "logedBefore")
        userDefaults.synchronize()
        
        let faceIdBtn = app.buttons["faceIdBtn"]
        
        if faceIdBtn.exists {
            faceIdBtn.tap()
            
            let homePageLabel = app.staticTexts["Busqueda de libros"]
            let labelExists = homePageLabel.waitForExistence(timeout: 15)
            
            if labelExists {
                XCTAssert(true, "Se cargó la página de inicio correctamente")
                return
            } else {
                XCTFail("No se encontró el texto 'Busqueda de libros' después de presionar Face ID")
            }
        } else {
            XCTFail("No se encontró el botón Face ID")
        }
    }
    
    
    func testGoogleLoginButton() {
        let googleLoginButton = app.buttons["googleBtn"]
        XCTAssertTrue(googleLoginButton.exists)
        
        googleLoginButton.tap()
    }
}
