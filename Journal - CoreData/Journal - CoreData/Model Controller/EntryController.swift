//
//  EntryController.swift
//  Journal - CoreData
//
//  Created by Nichole Davidson on 4/20/20.
//  Copyright © 2020 Nichole Davidson. All rights reserved.
//

import CoreData

enum NetworkError: Error {
    case noIdentifier
    case otherError
    case noData
    case noDecode
    case noEncode
    case noRep
}


class EntryController {
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    let baseURL = URL(string: "https://coredata-journal.firebaseio.com/")!
    
    func sendEntryToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        
        let requestURL = baseURL.appendingPathComponent(entry.identifier).appendingPathExtension("json")
    }
    
    
//    var entry: Entry?
//
//    func saveToPersistentStore() {
//        guard entry != nil else { return }
//
//        do {
//            try CoreDataStack.shared.mainContext.save()
//        } catch {
//            NSLog("Error saving managed object context: \(error)")
//            return
//        }
//
//    }
//
//    func loadFromPersistentStore() -> [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        let context = CoreDataStack.shared.mainContext
//        do {
//            return try context.fetch(fetchRequest)
//        } catch {
//            NSLog("Error fetching entries: \(error)")
//            return []
//        }
//    }
//
//    var entries: [Entry] {
//           loadFromPersistentStore()
//          }
//
//    func create(title: String, timestamp: Date, bodyText: String, mood: String) {
//
//        let _ = Entry(title: title, timestamp: timestamp, mood: mood)
//
//        do {
//            try CoreDataStack.shared.mainContext.save()
//        } catch {
//            NSLog("Error creating new managed object context: \(error)")
//        }
//
//        saveToPersistentStore()
//    }
//
//    func update(title: String, timestamp: Date, bodyText: String, mood: String) {
//
//        entry?.title = title
//        entry?.bodyText = bodyText
//        let date = Date()
//        entry?.timestamp = date
//        entry?.mood = mood
//
//        saveToPersistentStore()
//
//    }
//
//    func delete(entry: Entry) {
//
//        CoreDataStack.shared.mainContext.delete(entry)
//
//        do {
//            try CoreDataStack.shared.mainContext.save()
//        } catch {
//            NSLog("Error deleting the entry: \(error)")
//            return
//        }
//    }
}
