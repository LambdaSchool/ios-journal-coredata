//
//  CoreDataStack.swift
//  CoreDataJournal
//
//  Created by Austin Potts on 9/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let share = CoreDataStack()
    
    private init() {
        
    }
    
    
    //Create Code Snippet
    //Making The Box
    //Lazy means it doesn't create the property upon init, but only init when its called first time
    lazy var container: NSPersistentContainer = {
        
        
        //See if I have Entity
        let container = NSPersistentContainer(name: "Tasks")
        
        //Then load the stores
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Error loading Persistent Stores: \(error)")
            }
        })
        return container
    }()
    
    
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    //Make a function to save to persistent store
    func save(context: NSManagedObjectContext = CoreDataStack.share.mainContext) {
        context.performAndWait {
            
        
        do{
            try context.save()
        } catch {
            NSLog("Error saving context \(error)")
            mainContext.reset()
         }
        }
    }
    
    
    
}
