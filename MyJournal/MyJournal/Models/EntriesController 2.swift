//
//  EntriesController.swift
//  MyJournal
//
//  Created by Eoin Lavery on 02/10/2019.
//  Copyright © 2019 Eoin Lavery. All rights reserved.
//

import Foundation
import CoreData

class EntriesController {
    
    func saveToPersistentStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving to persistent store: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            print("Error fetching data from persistent store: \(error)")
            return []
        }
    }
    
    func createEntry(name: String, bodyText: String, mood: String) {
        let _ = Entry(name: name, bodyText: bodyText, mood: mood)
        saveToPersistentStore()
    }

    func updateEntry(name: String, bodyText: String, mood: String, entry: Entry) {
        entry.name = name
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) -> Bool {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        
        do {
            try moc.save()
            return true
        } catch {
            moc.reset()
            print("Error deleting Entry from managed object context in CoreDataStack: \(error)")
            return false
        }
    }
    
}
