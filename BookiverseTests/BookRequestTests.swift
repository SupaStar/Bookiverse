//
//  BookRequestTests
//  BookiverseTests
//
//  Created by Obed Martinez on 21/12/23
//



import XCTest
@testable import Bookiverse

final class BookRequestTests: XCTestCase {
    var viewModel: BookRequestViewModel!
    var mockBookRequest: BookRequest!
    
    override func setUpWithError() throws {
        mockBookRequest = BookRequest()
        viewModel = BookRequestViewModel(dataService: mockBookRequest)
    }
    
    override func tearDownWithError() throws {
        mockBookRequest = nil
        viewModel = nil
    }
    
    func testFetchBooks() {
        let expectation = XCTestExpectation(description: "Books fetched successfully")
        
        viewModel.didFinishFetch = { [weak self] in
            XCTAssertTrue(self?.viewModel.errorMessage ?? "" == "")
            XCTAssertNotNil(self?.viewModel.books)
            XCTAssertTrue(self?.viewModel.books?.count ?? 0 > 0)
            expectation.fulfill()
        }
        viewModel.showAlertClosure = { [weak self] in
            XCTAssertTrue(self?.viewModel.errorMessage ?? "" != "")
            expectation.fulfill()
        }
        viewModel.requestBooks(search: "Harry Potter")
        wait(for: [expectation], timeout: 5)
    }
    
    func testFetchBookDetail() {
        let expectation = XCTestExpectation(description: "Book detail fetched successfully")
        
        viewModel.didFinishFetch = { [weak self] in
            XCTAssertTrue(self?.viewModel.errorMessage ?? "" == "")
            XCTAssertNotNil(self?.viewModel.book)
            XCTAssertEqual(self?.viewModel.book?.volumeInfo.title, "La invasión de Estados Unidos a Panamá")
            if let authors = self?.viewModel.book?.volumeInfo.authors {
                XCTAssertEqual(authors[0], "Ricaurte Soler")
            }
            expectation.fulfill()
        }
        
        viewModel.showAlertClosure = { [weak self] in
            XCTAssertTrue(self?.viewModel.errorMessage ?? "" != "")
            expectation.fulfill()
        }
        
        viewModel.getBookDetail(id: "7X6SRDD4_9sC")
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testErrorMessage() {
        let expectation = XCTestExpectation(description: "Error message handled")
        
        viewModel.showAlertClosure = { [weak self] in
            XCTAssertTrue(self?.viewModel.errorMessage ?? "" != "")
            expectation.fulfill()
        }
        viewModel.requestBooks(search: "")
        
        wait(for: [expectation], timeout: 5)
    }
    
}
