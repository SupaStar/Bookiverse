//
//  BookDetailViewController
//  Bookiverse
//
//  Created by Obed Martinez on 19/12/23
//



import UIKit

class BookDetailViewController: UIViewController {
    
    // MARK: Variables
    var book: BookModel?
    var user: UserEntity?
    var isSaved: Bool = false
    
    // MARK: Injections
    var persistanceS: PersistenceService = PersistenceService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        
        guard let id = UserDefaults.standard.string(forKey: UserDefaultEnum.idUser.rawValue),
              let user = persistanceS.getUser(id: id),
              let book = self.book else {
            return
        }
        
        self.user = user
        self.isSaved = persistanceS.hasSavedBook(user: user, id: book.id, title: book.volumeInfo.title)
        updateNavigationBarButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func saveFav() {
        guard let user = self.user, let book = self.book else {
            return
        }
        
        if self.isSaved {
            persistanceS.deleteBook(user: user, id: book.id, title: book.volumeInfo.title)
        } else {
            persistanceS.saveBook(user: user, id: book.id, title: book.volumeInfo.title, publisher: book.volumeInfo.publisher, publishDate: book.volumeInfo.publishedDate, author: book.volumeInfo.authors[0])
        }
        
        self.isSaved.toggle()
        updateNavigationBarButton()
    }
    
    private func updateNavigationBarButton() {
        let imgName = self.isSaved ? "star.fill" : "star"
        let save = UIBarButtonItem(image: UIImage(systemName: imgName),
                                   style: .plain,
                                   target: self,
                                   action: #selector(saveFav))
        
        // Asignar el botón a la barra de navegación
        self.navigationItem.rightBarButtonItem = save
    }
}
