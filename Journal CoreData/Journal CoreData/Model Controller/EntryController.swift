//
//  EntryController.swift
//  Journal CoreData
//
//  Created by Ilgar Ilyasov on 9/24/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // MARK: - Properties
    
    let baseURL = URL(string: "https://journal-coredata-b5a96.firebaseio.com/")
    
//    var entries: [Entry] {
//        return loadFromPersistentStore()
//    }
    
    // MARK: - Persistent functions
    
    func savetoPersistentStore() {
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving to Persistent Store: \(error)")
        }
    }
    
    func put(entry: Entry, completion: @escaping ) {
        
    }
    
//    func loadFromPersistentStore() -> [Entry] {
//        
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        let moc = CoreDataStack.shared.mainContext
//        
//        do {
//            return try moc.fetch(fetchRequest)
//        } catch {
//            NSLog("Error fetching data: \(error)")
//            return []
//        }
//    }
    
    // MARK: - CRUD functions
    
    func createEntry(title: String, bodyText: String, mood: Mood) {
        _ = Entry(title: title, bodyText: bodyText, mood: mood)
        savetoPersistentStore()
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: Mood) {
//        guard let index = entries.index(of: entry) else { return }
//
//        entries[index].title = title
//        entries[index].bodyText = bodyText
//        entries[index].timestamp = Date()
        
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood.rawValue
        entry.timestamp = Date()
        
        savetoPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {
        
        let moc = CoreDataStack.shared.mainContext
//        let fetchEntries: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
//            let entries = try moc.fetch(fetchEntries)
//            guard let index = entries.index(of: entry) else {return}
//            let deletedEntry = entries[index]
            
            moc.delete(entry)
            try moc.save()
        } catch {
            moc.reset()
            NSLog("Error deleting entry: \(error)")
        }
    }
}
