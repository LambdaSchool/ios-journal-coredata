//
//  EntryController.swift
//  Journal Core Data
//
//  Created by Dillon McElhinney on 9/17/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // MARK: - Properties
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
    
    // MARK: - CRUD Methods
    func createEntry(title: String, bodyText: String) {
        _ = Entry(title: title, bodyText: bodyText)
        
        saveToPersistentStore()
    }
    
    func update(entry: Entry, title: String, bodyText: String) {
        entry.title = title
        entry.bodyText = bodyText
        
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        
        saveToPersistentStore()
    }
    
    // MARK: - Persistence
    private func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context to persistent store: \(error)")
        }
    }
    
    private func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            let entries = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            return entries
        } catch {
            NSLog("Error fetching entries from persistent store: \(error)")
            return []
        }
    }
}
