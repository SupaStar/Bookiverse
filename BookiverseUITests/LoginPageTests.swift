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
        
        
//        let passwordTextField = app.textFields["passwordTxt"]
//        XCTAssertTrue(passwordTextField.exists)
//        passwordTextField.tap()
//        passwordTextField.typeText("password123")
        
        let loginButton = app.buttons["loginBtn"]
        XCTAssertTrue(loginButton.exists)
        loginButton.tap()
        
    }
    
    func testRegisterButton() {
        let registerButton = app.buttons["registrateBtn"]
        XCTAssertTrue(registerButton.exists)
        
        registerButton.tap()
        
    }
    
    func testAnonymousLoginButton() {
        let anonymousLoginButton = app.buttons["anonymBtn"]
        XCTAssertTrue(anonymousLoginButton.exists)
        
        anonymousLoginButton.tap()
    }
    
    func testGoogleLoginButton() {
        let googleLoginButton = app.buttons["googleBtn"]
        XCTAssertTrue(googleLoginButton.exists)
        
        googleLoginButton.tap()
    }
}
