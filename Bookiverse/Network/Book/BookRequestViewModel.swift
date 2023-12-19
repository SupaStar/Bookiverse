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
    
    private var bookRequest: BookRequest?
    
    var errorMessage: String? = ""{
        didSet {
            if errorMessage != "" && errorMessage != nil {
                showAlertClosure?()
            }
        }
    }
    
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    // MARK: - Constructor
    init(dataService: BookRequest) {
        self.bookRequest = dataService
    }
    
    // MARK: Methods
    func requestBooks(search: String){
        self.bookRequest?.loadBooks(search: search) { books, errorMessage in
            if errorMessage != "" {
                self.errorMessage = errorMessage
                return
            }
            self.books = books
        }}
}
