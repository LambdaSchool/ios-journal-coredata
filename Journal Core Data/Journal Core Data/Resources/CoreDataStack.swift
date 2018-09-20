//
//  CoreDataStack.swift
//  Journal Core Data
//
//  Created by Dillon McElhinney on 9/17/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import Foundation
import CoreData

/// Utility class for dealing with the CoreData stack
class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Journal-Core-Data")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext  {
        return container.viewContext
    }
}
