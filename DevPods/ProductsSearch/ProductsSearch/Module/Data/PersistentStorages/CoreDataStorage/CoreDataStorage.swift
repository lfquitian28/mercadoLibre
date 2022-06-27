//
//  CoreDataStorage.swift
//  ProductUIKIT
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//

import CoreData

enum CoreDataStorageError: Error {
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
}

public final class CoreDataStorage {

    public static let shared = CoreDataStorage()
    
    public init() {}

    // MARK: - Core Data stack
    public lazy var persistentContainer: NSPersistentContainer = {
        guard let modelUrl = Bundle(for: Self.self).url(forResource: "CoreDataStorage", withExtension: "momd"),
            let mom = NSManagedObjectModel(contentsOf: modelUrl)
        else {
            fatalError("Unable to located Core Data Model")
        }
        let container = NSPersistentContainer(name: "CoreDataStorage", managedObjectModel: mom)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                // TODO: - Log to Crashlytics
                assertionFailure("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    // MARK: - Core Data Saving support
    public func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // TODO: - Log to Crashlytics
                assertionFailure("CoreDataStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }

    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
}
