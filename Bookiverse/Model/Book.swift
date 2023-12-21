//
//  Libro
//  Bookiverse
//
//  Created by Obed Martinez on 19/12/23
//



import Foundation

struct BookModel: Codable {
    let id: String
    let volumeInfo: BookInfo
}

struct BookInfo: Codable {
    let title: String
    let subtitle: String?
    let authors: [String]?
    let publisher: String?
    let publishedDate: String?
}

struct BookResponse: Codable {
    let items: [BookModel]
    let totalItems: Int
}
