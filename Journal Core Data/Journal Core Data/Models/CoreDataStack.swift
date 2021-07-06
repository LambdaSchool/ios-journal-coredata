//
//  CoreDataStack.swift
//  Journal Core Data
//
//  Created by Bhawnish Kumar on 3/23/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack() // property is connected directly to the class.
    
    // when we add the lazy it will run the property when we need it or call it.
   lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "JournalCoreData")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load the persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
