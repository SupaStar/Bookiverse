//
//  BookTableViewCell
//  Bookiverse
//
//  Created by Obed Martinez on 19/12/23
//



import UIKit

class BookTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var publishDate: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var publisher: UILabel!
    
    // MARK: Variables
    var book: BookModel? {
        didSet {
            title.text = book?.volumeInfo.title
            if let authors = book?.volumeInfo.authors, authors.count > 0 {
                author.text = authors[0].capitalized
            } else {
                author.text = "Sin autor"
            }
            if let publisherT = book?.volumeInfo.publisher {
                publisher.text = publisherT
            } else {
                publisher.text = "Sin publisher"
            }
            if let publishedDateT = book?.volumeInfo.publishedDate {
                publishDate.text = publishedDateT
            } else {
                publishDate.text = "Sin fecha de publicación"
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
