//
//  CoreDataManager.swift
//  News
//
//  Created by 송우진 on 10/3/24.
//

import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "News")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                NSLog("Unresolved error: %@", error.localizedDescription)
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                NSLog("Save Context error: %@", error.localizedDescription)
            }
        }
    }
}

extension CoreDataManager {
    func create<T: NSManagedObject>(
        _ objectType: T.Type,
        configure: (T) -> Void
    ) {
        let entityName = String(describing: objectType)
        guard let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? T else {
            return NSLog("Failed to create entity: \(entityName)")
        }
        configure(entity)
        saveContext()
    }
    
    func batchInsert<T: NSManagedObject>(
        _ objectType: T.Type,
        data: [[String: Any]]
    ) {
        let entityName = String(describing: objectType)
        
        let batchInsert = NSBatchInsertRequest(entityName: entityName, objects: data)
        
        do {
            try context.execute(batchInsert)
            saveContext()
        } catch {
            NSLog("Failed to batch insert for \(entityName): \(error.localizedDescription)")
        }
    }
    
    func fetch<T: NSManagedObject>(_ objectType: T.Type) -> [T] {
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        do {
            return try context.fetch(fetchRequest)
        } catch {
            NSLog("Failed to fetch for \(entityName): %@", error.localizedDescription)
            return []
        }
    }
    
    func update<T: NSManagedObject>(
        _ objectType: T.Type,
        predicate: NSPredicate,
        configure: (T) -> Void
    ) {
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.predicate = predicate
        do {
            let objects = try context.fetch(fetchRequest)
            if let objectToUpdate = objects.first {
                configure(objectToUpdate)
                saveContext()
            }
        } catch {
            NSLog("Failed to update for \(entityName): %@", error.localizedDescription)
        }
        
    }
    
    func deleteAll<T: NSManagedObject>(_ objectType: T.Type) {
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            NSLog("Failed to delete all for \(entityName): %@", error.localizedDescription)
        }
    }
}
