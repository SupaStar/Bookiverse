//
//  BookRequest
//  Bookiverse
//
//  Created by Obed Martinez on 19/12/23
//



import Foundation

class BookRequest {
    func loadBooks(search: String, completion: @escaping(([BookModel], String)->Void)){
        guard let url = makeURL(search: search) else {
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
                    // Parsear los datos recibidos a objetos de tipo BookModel
                    let bookResponse = try JSONDecoder().decode(BookResponse.self, from: data)
                    completion(bookResponse.items, "")
                } catch {
                    
                    completion([], error.localizedDescription)
                }
            }
        }
        petition.resume()
    }
}
