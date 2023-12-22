//
//  HomeViewController
//  Bookiverse
//
//  Created by Obed Martinez on 19/12/23
//



import UIKit
import FirebaseAuth

class HomeTableViewController: UITableViewController {
    // MARK: Variables
    var books: [BookModel] = []
    var selectedBook: BookModel?
    
    var booksVM: BookRequestViewModel = BookRequestViewModel(dataService: BookRequest())
    var persistanceS: PersistenceService = PersistenceService()
    var searchBar : SearchBookTableViewCell?
    let loader = Loader()
    
    var limit: Int = 10
    var offset: Int = 0
    var numberPetitions = 0
    
    var search: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Busqueda de libros"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        UserDefaults.standard.set(true, forKey: UserDefaultEnum.logedBefore.rawValue)
        
        let signOut = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right.fill"), style: .plain, target: self, action: #selector(closeSession))
        signOut.accessibilityIdentifier = "closeSessionBtn"
        
        self.navigationItem.rightBarButtonItem = signOut
        
        setupUser()
    }
    
    @objc func closeSession(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegue(withIdentifier: "goLogin", sender: self)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func setupUser() {
        // MARK: Quitar a futuro, valor id hardcode
//        UserDefaults.standard.set("0000", forKey: UserDefaultEnum.idUser.rawValue)
        
        if let id = UserDefaults.standard.string(forKey: UserDefaultEnum.idUser.rawValue) {
            if persistanceS.getUser(id: id) == nil {
                persistanceS.saveUser(id: id)
            }
        }
        loadBooks()
    }
    
    func loadBooks(refresh: Bool = false){
        guard let search = search else {
            self.books = []
            tableView.reloadData()
            return
        }
        //        loader.show(in: self)
        booksVM.requestBooks(search: search, offset: offset, limit: limit)
        booksVM.didFinishFetch = { [weak self] in
            if refresh {
                self?.books = self?.booksVM.books ?? []
            } else {
                self?.books.append(contentsOf: self?.booksVM.books ?? [])
            }
            self?.hideLoader()
        }
        booksVM.showAlertClosure = { [weak self] in
            self?.hideLoader()
            if let message = self?.booksVM.errorMessage, !message.isEmpty, let self = self {
                CommonUtils.alert(message: message, title: "Error", origin: self)
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if books.isEmpty {
            return 2
        }
        return books.count + 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
        }
        if books.isEmpty {
            if indexPath.row == 1 {
                return 200
            }
        }
        return 70
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchBookVC", for: indexPath) as! SearchBookTableViewCell
            cell.originVC = self
            self.searchBar = cell
            return cell
        }
        if books.isEmpty {
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "emptyBooks", for: indexPath)
                return cell
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookVC", for: indexPath) as! BookTableViewCell
        cell.book = books[indexPath.row - 1]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        let cell = tableView.cellForRow(at: indexPath) as! BookTableViewCell
        selectedBook = cell.book
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "bookDetail", sender: self)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.bounds.height
        
        if books.isEmpty || (searchBar?.limit ?? 0) > books.count {
            return
        }
        
        // Si el usuario scrollea al final de la tabla, carga mas datos
        if offsetY > contentHeight - screenHeight {
            if numberPetitions == 0 {
                numberPetitions = 1
                self.tableView.tableFooterView = createSpinnerFooter()
                if let searchBar = self.searchBar {
                    offset = (offset + searchBar.limit) + 1
                } else {
                    offset = offset + 10
                }
                self.loadBooks()
            }
        }
    }
    
    // Crea un spinner para el final de la tabla
    func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        spinner.color = .black
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
    
    @objc func hideLoader(delayTime: Double = 1.0){
        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime, execute: {
            self.tableView.tableFooterView = nil
            self.tableView.reloadData()
            self.numberPetitions = 0
            //self.loader.hide()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookDetail", let destinationVC = segue.destination as? BookDetailViewController {
            destinationVC.book = selectedBook
        }
    }
}
