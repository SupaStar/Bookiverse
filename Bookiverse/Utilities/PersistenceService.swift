//
//  PersistenceService
//  Bookiverse
//
//  Created by Obed Martinez on 19/12/23
//



import Foundation
import CoreData

class PersistenceService {
    private let container: NSPersistentContainer
    private let containerName: String = "Bookiverse"
    
    init(){
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
        }
    }
    
    func getUser(id: String) -> UserEntity? {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                return user
            }
        } catch {
            print("Error fetching user: \(error)")
            return nil
        }
        return nil
    }
    
    func saveUser(id: String) {
        let entity = UserEntity(context: container.viewContext)
        entity.id = id
        save()
    }
    
    func saveBook(user: UserEntity, id: String, title: String, publisher: String, publishDate: String, author: String){
        let entity = SavedBookEntity(context: container.viewContext)
        entity.id = id
        entity.title = title
        entity.publisher = publisher
        entity.publishDate = publishDate
        entity.author = author
        user.addToSavedBooks(entity)
        save()
    }
    
    func deleteBook(user: UserEntity, id: String, title: String) {
        if let books = user.savedBooks {
            for case let savedBook as SavedBookEntity in books {
                if savedBook.id == id && savedBook.title == title{
                    user.removeFromSavedBooks(savedBook)
                    container.viewContext.delete(savedBook)
                    save()
                    return
                }
            }
        }
    }
    
    func getAllSavedBooks(user: UserEntity) -> [SavedBookEntity] {
        if let books = user.savedBooks {
            return books.array as? [SavedBookEntity] ?? []
        }
        return []
    }
    
    func hasSavedBook(user: UserEntity, id: String, title: String) -> Bool {
        if let books = user.savedBooks {
            for case let savedBook as SavedBookEntity in books {
                if savedBook.id == id && savedBook.title == title {
                    return true
                }
            }
        }
        return false
    }
    
    func save(){
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
}
