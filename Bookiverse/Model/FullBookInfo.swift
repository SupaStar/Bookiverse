//
//  FullBookInfo
//  Bookiverse
//
//  Created by Obed Martinez on 20/12/23
//



import Foundation

struct FullBookInfo: Codable {
    let volumeInfo: VolumeInfo
    
    struct VolumeInfo: Codable {
        let title: String
        let subtitle: String?
        let authors: [String]?
        let publisher: String?
        let publishedDate: String?
        let description: String?
        let industryIdentifiers: [IndustryIdentifier]?
        let pageCount: Int?
        let printType: String?
        let mainCategory: String?
        let categories: [String]?
        let averageRating: Double?
        let ratingsCount: Int?
        let contentVersion: String?
        let imageLinks: ImageLinks?
        let language: String?
        let previewLink: String?
        let infoLink: String?
        let canonicalVolumeLink: String?
        
        struct IndustryIdentifier: Codable {
            let type: String
            let identifier: String
        }
        
        struct ImageLinks: Codable {
            let smallThumbnail: String?
            let thumbnail: String?
            let small: String?
            let medium: String?
            let large: String?
            let extraLarge: String?
        }
    }
    
}
