//
//  EntryController.swift
//  Journal
//
//  Created by Lambda_School_Loaner_259 on 3/23/20.
//  Copyright © 2020 DeVitoC. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
    
    
    // MARK: - Persistent Store
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context (saving to persistent store): \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let context = CoreDataStack.shared.mainContext
        do {
            return try context.fetch(fetchRequest)
        } catch {
            NSLog("Error loading journal entries from core Data: \(error)")
            return []
        }
    }
    
    // MARK: - CRUD
    func createEntry(title: String, bodyText: String, timestamp: Date, context: NSManagedObjectContext) {
        let newEntry = Entry(title: title, bodyText: bodyText, timestamp: timestamp, context: CoreDataStack.shared.mainContext)
        context.insert(newEntry)
        do {
            try context.save()
        } catch {
            context.reset()
            NSLog("Error saving managed object context (adding journal entry): \(error)")
        }
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String) {
        guard let index = entries.firstIndex(of: entry) else { return }
        entries[index].title = title
        entries[index].bodyText = bodyText
        let context = CoreDataStack.shared.mainContext
        do {
            try context.save()
        } catch {
            context.reset()
            NSLog("Error saving managed object context (updating journal entry)")
        }
    }
    
    func deleteEntry(entry: Entry) {
        let context = CoreDataStack.shared.mainContext
        context.delete(entry)
        do {
            try context.save()
        } catch {
            context.reset()
            NSLog("Error saving managed object context (deleting journal entry)")
        }
    }
}

