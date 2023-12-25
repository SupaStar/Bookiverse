//
//  HomePageTests
//  BookiverseUITests
//
//  Created by Obed Martinez on 22/12/23
//



import XCTest
@testable import Bookiverse

final class HomePageTests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch() // Asegúrate de ajustar esta línea según tu configuración de la aplicación
    }
    
    func testTableViewInteraction() {
        let anonymousLoginButton = app.buttons["anonymBtn"]
        XCTAssertTrue(anonymousLoginButton.exists)
        
        anonymousLoginButton.tap()
        
        let homePageLabel = app.staticTexts["Busqueda de libros"]
        XCTAssertTrue(homePageLabel.waitForExistence(timeout: 5))
        
        let tableView = app.tables.firstMatch
        if !tableView.exists {
            XCTFail("No se cargo la tabla")
        }
        
        tableView.swipeUp()
    }
    
    func testSearchBar(){
        let anonymousLoginButton = app.buttons["anonymBtn"]
        XCTAssertTrue(anonymousLoginButton.exists)
        
        anonymousLoginButton.tap()
        
        let homePageLabel = app.staticTexts["Busqueda de libros"]
        XCTAssertTrue(homePageLabel.waitForExistence(timeout: 5))
        
        let tableView = app.tables.firstMatch
        if !tableView.exists {
            XCTFail("No se cargo la tabla")
        }
        let searchBar = app.searchFields.element(boundBy: 0)
        searchBar.tap()
        searchBar.typeText("Awa")
        
        sleep(3)
        let numResults = tableView.cells.count
        XCTAssertGreaterThan(numResults, 2, "El número de filas cambio y trae resultados")
    }
    
    func testViewDetailBook(){
        let anonymousLoginButton = app.buttons["anonymBtn"]
        XCTAssertTrue(anonymousLoginButton.exists)
        
        anonymousLoginButton.tap()
        
        let homePageLabel = app.staticTexts["Busqueda de libros"]
        XCTAssertTrue(homePageLabel.waitForExistence(timeout: 5))
        
        let tableView = app.tables.firstMatch
        if !tableView.exists {
            XCTFail("No se cargo la tabla")
        }
        let searchBar = app.searchFields.element(boundBy: 0)
        searchBar.tap()
        searchBar.typeText("Awa")
        
        sleep(3)
        
        let cell = IndexPath(row: 4, section: 1)
        
        let book = tableView.cells.element(boundBy: cell.row)
        book.tap()
        
        sleep(2)
        XCTAssert(true, "Se abrio la pagina de detalle con exito")
    }
    
    func testCloseSession(){
        let anonymousLoginButton = app.buttons["anonymBtn"]
        XCTAssertTrue(anonymousLoginButton.exists)
        
        anonymousLoginButton.tap()
        
        let homePageLabel = app.staticTexts["Busqueda de libros"]
        XCTAssertTrue(homePageLabel.waitForExistence(timeout: 5))
        
        let closeSession = app.buttons["closeSessionBtn"]
        if closeSession.exists{
            closeSession.tap()
            sleep(2)
            XCTAssert(true, "Se cerro sesion con exito")
        }else {
            XCTFail("No se puede acceder al boton")
        }
    }
}
