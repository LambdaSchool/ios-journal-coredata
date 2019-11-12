//
//  EntryController.swift
//  Journal
//
//  Created by Jon Bash on 2019-11-11.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import Foundation

class EntryController {
    
    // MARK: - Properties
    
    var coreDataStack = CoreDataStack()
    
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
    
    // MARK: - CRUD
    
    func create(entryWithTitle title: String, body: String) {
        let _ = Entry(title: title, bodyText: body, context: coreDataStack.mainContext)
        saveToPersistentStore()
    }
    
    func update(entry: Entry, withNewTitle title: String, body: String) {
        entry.title = title
        entry.bodyText = body
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        coreDataStack.mainContext.delete(entry)
        saveToPersistentStore()
    }
    
    // MARK: - Save/Load
    
    func saveToPersistentStore() {
        let moc = coreDataStack.mainContext
        do {
            try moc.save()
        } catch {
            print("Error saving journal entries: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest = coreDataStack.fetchRequest()
        let moc = coreDataStack.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            print("Error fetching journal entries: \(error)")
            return []
        }
    }
}
