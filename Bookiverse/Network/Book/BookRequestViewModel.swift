//
//  BookRequest
//  Bookiverse
//
//  Created by Obed Martinez on 19/12/23
//



import Foundation

class BookRequestViewModel {
    // MARK: Properties
    var books: [BookModel]? {
        didSet { self.didFinishFetch?() }
    }
    var book: FullBookInfo? {
        didSet { self.didFinishFetch?() }
    }
    
    private var bookRequest: BookRequest?
    
    var errorMessage: String? = ""{
        didSet {
            if errorMessage != "" && errorMessage != nil {
                showAlertClosure?()
            }
        }
    }
    
    var showAlertClosure: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    // MARK: - Constructor
    init(dataService: BookRequest) {
        self.bookRequest = dataService
    }
    
    // MARK: Methods
    func requestBooks(search: String, offset: Int = 0, limit: Int = 10){
        self.bookRequest?.loadBooks(search: search, offset: offset, limit: limit) { books, errorMessage in
            if errorMessage != "" {
                self.errorMessage = errorMessage
                return
            }
            self.books = books
        }
    }
    
    func getBookDetail(id: String){
        self.bookRequest?.loadDetailBook(id: id){ book, errorMessage in
            if errorMessage != "" {
                self.errorMessage = errorMessage
                return
            }
            self.book = book
        }
    }
}
