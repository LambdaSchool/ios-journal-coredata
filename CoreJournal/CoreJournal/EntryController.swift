//
//  EntryController.swift
//  CoreJournal
//
//  Created by Jocelyn Stuart on 2/11/19.
//  Copyright © 2019 JS. All rights reserved.
//

import UIKit
import CoreData

class EntryController {
    
    func saveToPersistentStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save() // Save the task to the persistent store.
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        // We could say what kind of tasks we want fetched.
        
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return []
        }
        
    }
    
    let dateFormatter = DateFormatter()
    
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
    
   func create(withTitle title: String, andBody bodyText: String){
    _ = Entry(title: title, bodyText: bodyText, timestamp: Date(), identifier: UUID().uuidString)
        saveToPersistentStore()
    }
    
    func update(withEntry entry: Entry, andTitle title: String, andBody bodyText: String) {
        guard let index = entries.index(of: entry) else { return }
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
       // let timeText = dateFormatter.string(from: entry.timestamp)
        
        entries[index].title = title
        entries[index].bodyText = bodyText
        entries[index].timestamp = Date()
        
        saveToPersistentStore()
    }
    
    func delete(withEntry entry: Entry) {
       /* guard let index = entries.index(of: entry) else {return}
        entries.remove(at: index)*/
        
        let moc = CoreDataStack.shared.mainContext
        
        moc.delete(entry) // Remove from the MOC, but not the persistent store
        
        do {
            try moc.save() // Carry the removal of the task, from the MOC, to the persistent store
        } catch {
            moc.reset()
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
}
