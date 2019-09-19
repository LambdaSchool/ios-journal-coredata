//
//  EntryController.swift
//  Journal-CoreData
//
//  Created by Ciara Beitel on 9/16/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving context: \(error)")
            CoreDataStack.shared.mainContext.reset()
        }
    }
    
    func createEntry(title: String, bodyText: String, timestamp: Date, identifier: String, mood: String) -> Entry {
        let entry = Entry(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifier, mood: mood, context: CoreDataStack.shared.mainContext)
        saveToPersistentStore()
        return entry
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
}
