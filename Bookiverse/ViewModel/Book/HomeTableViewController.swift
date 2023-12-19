//
//  HomeViewController
//  Bookiverse
//
//  Created by Obed Martinez on 19/12/23
//



import UIKit

class HomeTableViewController: UITableViewController {
    
    var books: [BookModel] = []
    var selectedBook: BookModel?
    
    var booksVM: BookRequestViewModel = BookRequestViewModel(dataService: BookRequest())
    var persistanceS: PersistenceService = PersistenceService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: Quitar a futuro, valor id hardcode
        UserDefaults.standard.set("0000", forKey: UserDefaultEnum.idUser.rawValue)
        
        if let id = UserDefaults.standard.string(forKey: UserDefaultEnum.idUser.rawValue) {
            if persistanceS.getUser(id: id) == nil {
                persistanceS.saveUser(id: id)
            }
        }
        
        loadBooks()
    }
    
    func loadBooks(refresh: Bool = false){
        booksVM.requestBooks(search: "a")
        booksVM.didFinishFetch = { [weak self] in
            if refresh {
                self?.books = self?.booksVM.books ?? []
            } else {
                self?.books.append(contentsOf: self?.booksVM.books ?? [])
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        self.booksVM.updateLoadingStatus = {
        }
        self.booksVM.showAlertClosure = {
            if let message = self.booksVM.errorMessage, !message.isEmpty {
                CommonUtils.alert(message: message, title: "Error", origin: self)
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookVC", for: indexPath) as! BookTableViewCell
        cell.book = books[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BookTableViewCell
        selectedBook = cell.book
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "bookDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookDetail"{
            if let destinationVC = segue.destination as? BookDetailViewController {
                destinationVC.book = selectedBook
            }
        }
    }
}
