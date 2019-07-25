//
//  COreDataStack.swift
//  Journal (CoreData)
//
//  Created by Nathan Hedgeman on 7/22/19.
//  Copyright © 2019 Nate Hedgeman. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        // Give the container the name of your data model file
        let container = NSPersistentContainer(name: "Entry")
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        })
        
        return container
    }()
    
    // This should help you remember to use the viewContext on the main thread only
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
