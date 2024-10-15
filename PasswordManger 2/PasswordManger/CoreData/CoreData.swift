

import CoreData
import Foundation

struct AcountsDetails: Identifiable, Encodable, Decodable {
    var id: String = UUID().uuidString
    var appName: String
    var mail: String
    var password: String
}

class CoreData {
    
    static let shared = CoreData()
    private init() {}
    
    // MARK: - Core Data stack
    private lazy var managedObjectContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AccountsCoreDataModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // MARK: - Save Account Data
    func saveAccount(_ account: AcountsDetails) {
        let context = managedObjectContext
        let entity = AccountEntity(context: context)
        entity.id = account.id
        entity.appName = account.appName
        entity.mail = account.mail
        entity.password = account.password
        
        saveContext()
    }

    // MARK: - Update Account Data
    func updateAccount(_ account: AcountsDetails) {
        let fetchRequest: NSFetchRequest<AccountEntity> = AccountEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", account.id)
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            if let entityToUpdate = results.first {
                entityToUpdate.appName = account.appName
                entityToUpdate.mail = account.mail
                entityToUpdate.password = account.password
                
                saveContext()
                print("Account updated successfully")
            }
        } catch {
            print("Error updating account: \(error)")
        }
    }
    
    // MARK: - Delete Account Data
    func deleteAccount(accountID: String) {
        let fetchRequest: NSFetchRequest<AccountEntity> = AccountEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", accountID)
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            if let entityToDelete = results.first {
                managedObjectContext.delete(entityToDelete)
                saveContext()
                print("Account deleted successfully")
            }
        } catch {
            print("Error deleting account: \(error)")
        }
    }
    
    // MARK: - Fetch Data from Core Data
    func fetchDataFromCoreData() -> [AcountsDetails] {
        let fetchRequest: NSFetchRequest<AccountEntity> = AccountEntity.fetchRequest()
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            let accounts = results.map { AcountsDetails(id: $0.id ?? "", appName: $0.appName ?? "", mail: $0.mail ?? "", password: $0.password ?? "") }
            print("Account list count: \(accounts.count)")
            return accounts
        } catch {
            print("Could not fetch: \(error)")
            return []
        }
    }
    
    // MARK: - Save Context
    private func saveContext() {
        let context = managedObjectContext
        do {
            try context.save()
            print("Context saved successfully")
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
