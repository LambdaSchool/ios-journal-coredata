//
//  CoreDataStack.swift
//  Core Data 1
//
//  Created by Sergey Osipyan on 1/18/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import Foundation
import CoreData


// Manager for getting data
class CoreDataStack {
    
    // Singleton
    static let shared = CoreDataStack()
    
    let container: NSPersistentContainer
    
    // How we interact with our data store
    let mainContext: NSManagedObjectContext
    
    // Init method
    init() {
        
        // Alternative: Use NSPersistentContainer
        
        // Create a container
        // Give it the name of your data model file
        container = NSPersistentContainer(name: "Jurnal")
        
        // Load the stores
        container.loadPersistentStores { (description, error) in
            if let e = error {
                fatalError("Couldn't load the data store: \(e)")
            }
        }
        
        mainContext = container.viewContext
        mainContext.automaticallyMergesChangesFromParent = true
    }
    func save(context: NSManagedObjectContext) throws {
        var saveError: Error?
        context.performAndWait {
            do {
                try context.save()
            } catch {
                saveError = error
            }
        }
        if let error = saveError { throw error }
    }
    
}


//
//class CoreDataStack {
//
//    static let shared = CoreDataStack()
//
//    lazy var container: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "Jurnal")
//        container.loadPersistentStores { (description, error) in
//            if let error = error {
//                fatalError("Couldn't load the data store: \(error)")
//            } else {
//                print("\(description.url!.path)")
//            }
//        }
//        return container
//    }()
//
//    var mainContext: NSManagedObjectContext {
//
//        return container.viewContext
//    }



    
    
    
//
//    let mainContext: NSManagedObjectContext
//    let container: NSPersistentContainer
//
//    init() {
//
    
        /*
      guard let managedObjectModel = NSManagedObjectModel.mergedModel(from: nil) else {
            fatalError("Can't finde a model to load!")
        }
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let documentFolder = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let datastoreFile = documentFolder.appendingPathComponent("tasks.db")
        _ = try! persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: datastoreFile, options: nil)
        
        let mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.persistentStoreCoordinator = persistentStoreCoordinator
        */
        // alternative: USE NSPersistentContainer
        
//        container = NSPersistentContainer(name: "Tasks")
//        container.loadPersistentStores {(desccription, error) in
//            if let error = error {
//                fatalError("Couldn't load the data store: \(error)")
//            }
//        }
//        mainContext = container.viewContext
//    }
//}
