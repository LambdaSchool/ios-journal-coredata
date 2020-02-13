//
//  EntryController.swift
//  Journal
//
//  Created by Sal Amer on 2/12/20.
//  Copyright © 2020 Sal Amer. All rights reserved.
//

import UIKit
import CoreData

class EntryController {
    
    var entries: [Entry] {
        loadFromPersistentStore()
    }

    func saveToPersistentStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error Saving Task: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            print("Error Fetching Entries: \(error)")
            return []
        }
    }
    
    // create Entry
    
//    func createEntry(withTitle title: String, bodyText: String) {
//           e.append(
//           saveToPersistentStore()
//       }
    
    func CreateEntry(title: String, bodytext: String, timestamp: Date, identifier: String) {
        let _ = Entry(title: title, bodytext: bodytext, timestamp: timestamp, identifier: identifier)
        saveToPersistentStore()
    }
    
    func Update(entry: Entry, newTitle: String, newBodyText: String) {
        let updatedTimeStamp = Date()
        entry.title = newTitle
        entry.bodytext = newBodyText
        entry.timestamp = updatedTimeStamp
        saveToPersistentStore()
        
//        //updte in array
//        guard let index = entries.firstIndex(of: entry) else {
//            print("Unable to update Entrycontroller using updat")
//            return
//        }
//        entries[index].title = newTitle
//        entries[index].bodytext = newBodyText
//        entries[index].timestamp = updatedTimeStamp
    }
    
    func Delete(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        
        do {
            try moc.save()
        } catch {
            moc.reset()
            print("Error saving deleted entry: \(error)")
        }
    }

}
