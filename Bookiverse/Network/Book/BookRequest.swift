//
//  BookRequest
//  Bookiverse
//
//  Created by Obed Martinez on 19/12/23
//



import Foundation

class BookRequest {
    func loadBooks(search: String, offset: Int, limit: Int, completion: @escaping(([BookModel], String)->Void)){
        let params: [String: String] = [
            "maxResults": "\(limit)",
            "startIndex": "\(offset)"
        ]
        guard let url = makeURL(search: search, parameters: params) else {
            completion([], "Ocurrio un error al crear la url")
            return
        }
        
        let petition = URLSession.shared.dataTask(with: url){ (data, response, error) in
            if let error = error {
                completion([], error.localizedDescription)
                return
            }
            if let data = data {
                do {
                    // Parsear los datos recibidos a objetos de tipo BookResponse
                    let bookResponse = try JSONDecoder().decode(BookResponse.self, from: data)
                    completion(bookResponse.items, "")
                } catch {
                    
                    completion([], error.localizedDescription)
                }
            }
        }
        petition.resume()
    }
    
    func loadDetailBook(id: String, completion: @escaping((FullBookInfo?, String)->Void)){
        let urlString = "\(apiURL)/\(id)"
        guard let url = URL(string: urlString) else {
            completion(nil, "Error al generar la url")
            return
        }
        
        let petition = URLSession.shared.dataTask(with: url){ (data, response, error) in
            if let error = error {
                completion(nil, error.localizedDescription)
                return
            }
            if let data = data {
                do {
                    // Parsear los datos recibidos a objetos de tipo BookModel
                    let bookResponse = try JSONDecoder().decode(FullBookInfo.self, from: data)
                    completion(bookResponse, "")
                } catch {
                    
                    completion(nil, error.localizedDescription)
                }
            }
        }
        petition.resume()
    }
}
