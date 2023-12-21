//
//  BookDetailViewController
//  Bookiverse
//
//  Created by Obed Martinez on 19/12/23
//



import UIKit

class BookDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var publisherLbl: UILabel!
    @IBOutlet weak var publishDateLbl: UILabel!
    @IBOutlet weak var printTypeLbl: UILabel!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var authorTableView: UITableView!
    @IBOutlet weak var industryIdentifiersTableView: UITableView!
    @IBOutlet weak var constraintTableAuthors: NSLayoutConstraint!
    @IBOutlet weak var constraintTableIndustry: NSLayoutConstraint!
    
    // MARK: Variables
    let loader = Loader()
    var acordionAuthor: Acordion = Acordion(name: "test", items: [], collapsed: true)
    var accordionIndustry: Acordion = Acordion(name: "test", items: [], collapsed: true)
    let collapseHeightTables: CGFloat = 44
    
    var book: BookModel? {
        didSet {
            if let book = book {
                title = book.volumeInfo.title
            }
        }
    }
    var user: UserEntity?
    var isSaved: Bool = false
    
    // MARK: Injections
    var persistanceS: PersistenceService = PersistenceService()
    var booksVM: BookRequestViewModel = BookRequestViewModel(dataService: BookRequest())
    
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
        loadBook()
        updateNavigationBarButton()
        setupTables()
    }
    
    func setupTables(){
        //Tabla de autores
        authorTableView.delegate = self
        authorTableView.dataSource = self
        authorTableView.layer.borderColor = UIColor.gray.cgColor
        authorTableView.layer.borderWidth = 1.0
        authorTableView.layer.cornerRadius = 8.0
        authorTableView.clipsToBounds = true
        constraintTableAuthors.constant = self.collapseHeightTables
        authorTableView.reloadData()
        
        industryIdentifiersTableView.delegate = self
        industryIdentifiersTableView.dataSource = self
        industryIdentifiersTableView.layer.borderColor = UIColor.gray.cgColor
        industryIdentifiersTableView.layer.borderWidth = 1.0
        industryIdentifiersTableView.layer.cornerRadius = 8.0
        industryIdentifiersTableView.clipsToBounds = true
        constraintTableIndustry.constant = self.collapseHeightTables
        industryIdentifiersTableView.reloadData()
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
            let authorToSave = book.volumeInfo.authors?.first ?? ""
            
            persistanceS.saveBook(
                user: user,
                id: book.id,
                title: book.volumeInfo.title,
                publisher: book.volumeInfo.publisher ?? "",
                publishDate: book.volumeInfo.publishedDate ?? "",
                author: authorToSave
            )
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
    
    func loadBook(){
        guard let book = book else { return }
        loader.show(in: self)
        booksVM.getBookDetail(id: book.id)
        booksVM.didFinishFetch = { [weak self] in
            if let book = self?.booksVM.book {
                DispatchQueue.main.sync {
                    self?.subtitleLbl.text = book.volumeInfo.subtitle?.capitalized
                    self?.publisherLbl.text = book.volumeInfo.publisher
                    self?.publishDateLbl.text = book.volumeInfo.publishedDate
                    self?.printTypeLbl.text = book.volumeInfo.printType
                    self?.languageLbl.text = "Idioma: \(book.volumeInfo.language ?? "NA")"
                    self?.descriptionLbl.text = book.volumeInfo.description?.stringByStrippingHTML()
                    self?.acordionAuthor = Acordion(name: "Autores", items: book.volumeInfo.authors ?? [], collapsed: true)
                    var accordionIndustry = Acordion(name: "Identificadores de industria", items: [], collapsed: true)
                    if let industry = book.volumeInfo.industryIdentifiers {
                        for value in industry {
                            let identifier = "\(value.type) \(value.identifier)"
                            accordionIndustry.items.append(identifier)
                        }
                    }
                    self?.accordionIndustry = accordionIndustry
                    self?.authorTableView.reloadData()
                    self?.industryIdentifiersTableView.reloadData()
                    self?.loadImage(urlString: book.volumeInfo.imageLinks?.thumbnail ?? "https://ia.edu.mx/wp-content/uploads/2021/08/placeholder-442-1.png")
                }
            }
        }
        booksVM.showAlertClosure = { [weak self] in
            self?.loader.hide()
            if let message = self?.booksVM.errorMessage, !message.isEmpty, let self = self {
                CommonUtils.alert(message: message, title: "Error", origin: self)
            }
        }
    }
    
    func loadImage(urlString: String){
        if let url = URL(string: urlString) {
            let session = URLSession.shared
            let task = session.dataTask(with: url) { data, response, error in
                // Comprueba si hay un error
                if let error = error {
                    self.loader.hide()
                    print("Error al descargar la imagen: \(error.localizedDescription)")
                    return
                }
                
                if let imageData = data {
                    if let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.loader.hide()
                            self.bookImage.image = image
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    // MARK: Tablas
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == authorTableView {
            return 1
        } else if tableView == industryIdentifiersTableView {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == authorTableView {
            return acordionAuthor.collapsed ? 1 : acordionAuthor.items.count + 1
        } else if tableView == industryIdentifiersTableView {
            return accordionIndustry.collapsed ? 1 : accordionIndustry.items.count + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        if tableView == authorTableView {
            if indexPath.row == 0 {
                cell.textLabel?.text = acordionAuthor.name
            } else {
                cell.textLabel?.text = acordionAuthor.items[indexPath.row - 1]
            }
        } else if tableView == industryIdentifiersTableView {
            if indexPath.row == 0 {
                cell.textLabel?.text = accordionIndustry.name
            } else {
                cell.textLabel?.text = accordionIndustry.items[indexPath.row - 1]
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if tableView == authorTableView {
                acordionAuthor.collapsed = !acordionAuthor.collapsed
                if acordionAuthor.collapsed {
                    constraintTableAuthors.constant = collapseHeightTables
                } else {
                    let expandedHeight = CGFloat(acordionAuthor.items.count + 1) * collapseHeightTables
                    constraintTableAuthors.constant = expandedHeight
                }
                authorTableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
            } else if tableView == industryIdentifiersTableView {
                accordionIndustry.collapsed = !accordionIndustry.collapsed
                if accordionIndustry.collapsed {
                    constraintTableIndustry.constant = collapseHeightTables
                } else {
                    let expandedHeight = CGFloat(accordionIndustry.items.count + 1) * collapseHeightTables
                    constraintTableIndustry.constant = expandedHeight
                }
                industryIdentifiersTableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
            }
        }
    }
}
