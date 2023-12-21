//
//  SavedBooksTableViewController
//  Bookiverse
//
//  Created by Obed Martinez on 19/12/23
//



import UIKit

class SavedBooksTableViewController: UITableViewController {

    var savedBooks: [SavedBookEntity] = []
    var user: UserEntity?
    var selectedBook: BookModel?

    var persistanceS: PersistenceService = PersistenceService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.persistanceS = PersistenceService()
        if let id = UserDefaults.standard.string(forKey: UserDefaultEnum.idUser.rawValue) {
            self.user = persistanceS.getUser(id: id)
            loadBooks()
            return
        }
    }

    func loadBooks(){
        guard let user = user else {
            self.savedBooks = []
            return
        }
        self.savedBooks = persistanceS.getAllSavedBooks(user: user)
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if savedBooks.count == 0 {
            return 1
        }
        return savedBooks.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if savedBooks.isEmpty {
            return 200
        }
        return 70
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if savedBooks.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyBookSaved", for: indexPath)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookVC", for: indexPath) as! BookTableViewCell
        let bookSelected = savedBooks[indexPath.row]
        let bookInf = BookInfo(title: bookSelected.title ?? "", subtitle: nil, authors: [bookSelected.author ?? ""],publisher: bookSelected.publisher ?? "", publishedDate: bookSelected.publishDate ?? "")
        let book = BookModel(id: bookSelected.id ?? "", volumeInfo: bookInf)
        cell.book = book
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BookTableViewCell
        selectedBook = cell.book
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "bookSavedDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookSavedDetail" {
            if let destinationVC = segue.destination as? BookDetailViewController {
                destinationVC.book = selectedBook
            }
        }
    }
}
