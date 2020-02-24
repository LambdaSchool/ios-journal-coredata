//
//  CoreDataStack.swift
//  Journal
//
//  Created by Lambda_School_Loaner_268 on 2/24/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        // The name below should match the filename of the xcdatamodeld file exactly (minus the extension)
        let ncontainer = NSPersistentContainer(name: "Journal")
        ncontainer.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Error! Can't Load from Persistent Stores: \(error!)!")
            }
        }
        return ncontainer
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
