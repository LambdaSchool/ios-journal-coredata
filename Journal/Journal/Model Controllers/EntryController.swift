//
//  EntryController.swift
//  Journal
//
//  Created by Scott Bennett on 9/24/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    init() {
        fetchEntriesFromServer()
    }
    
    typealias Completionhandler = (Error?) -> Void
    
    
    // MARK: - Core Data Methods

    // CREATE
    func create(title: String, bodyText: String, mood: EntryMood, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        let entry = Entry(title: title, bodyText: bodyText, mood: mood, context: context)
        
        do {
            try CoreDataStack.shared.save(context: context)
        } catch {
            NSLog("Error saving entry: \(error)")
        }
        
        put(entry: entry)
    }
    
    // UPDATE
    func update(entry: Entry, title: String, bodyText: String, mood: EntryMood) {
        
        entry.title =  title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood.rawValue
        
        put(entry: entry)
    }
    
    // DELETE
    func delete(entry: Entry) {
        
        let moc = CoreDataStack.shared.mainContext
        
        deleteEntryFromServer(entry: entry)
        
        moc.delete(entry)
        
        do {
            try CoreDataStack.shared.save(context: moc)
        } catch {
            moc.reset()
            NSLog("Error saving moc aster deleting task: \(error)")
        }

    }

    // FETCH SINGLE ENTRY FROM PERSISTENT STORE
    func fetchSingleEntryFromPersistentStore(identifier: String, context: NSManagedObjectContext) -> Entry? {
        
        guard let identifier = UUID(uuidString: identifier) else { return nil }
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let predicate = NSPredicate(format: "identifier == %@", identifier as NSUUID)
        fetchRequest.predicate = predicate
        
        var result: Entry? = nil
        context.performAndWait {
            do {
                result = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error fetching task with UUID \(identifier): \(error)")
            }
        }
        return result
    }


    static let baseURL = URL(string: "https://journalcoredata.firebaseio.com/")!
        
    
    // MARK: - Server Methods
    
    func update(entry: Entry, entryRepresentation: EntryRepresentation) {
        
        entry.title = entryRepresentation.title
        entry.bodyText  = entryRepresentation.bodyText
        entry.mood = entryRepresentation.mood
        entry.timestamp = entryRepresentation.timestamp
        entry.identifier = entryRepresentation.identifier
    }
        
    
    // FETCH ENTRIES FROM SERVER
    func fetchEntriesFromServer(completion: @escaping Completionhandler = { _ in }) {

        let requestURL = EntryController.baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(error)
                return
            }
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
                return
            }
            
            var entryRepresentations: [EntryRepresentation] = []
            
            do {
                entryRepresentations = try JSONDecoder().decode([String: EntryRepresentation].self, from: data).map({ $0.value })
                let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
                
                backgroundContext.performAndWait {
                    
                    for entryRep in entryRepresentations {
                        
                        let entry = self.fetchSingleEntryFromPersistentStore(identifier: entryRep.identifier, context: backgroundContext)
                        
                        if let entry = entry,  entry != entryRep {
                            self.update(entry: entry, entryRepresentation: entryRep)
                        } else if entry == nil {
                            let _ = Entry(entryRepresentation: entryRep, context: backgroundContext)
                        }
                    }
                    
                    do {
                        try CoreDataStack.shared.save(context: backgroundContext)
                    } catch {
                        NSLog("Error saving background context: \(error)")
                    }
                }
                
                completion(nil)
                
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(error)
                return
            }
            
        }.resume()
    }

    
    // PUT ENTRY ON SERVER
    func put(entry: Entry, completion: @escaping Completionhandler = { _ in }) {
        
        let identifier = entry.identifier ?? UUID().uuidString
        
        let requestURL = EntryController.baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            
            request.httpBody = try JSONEncoder().encode(entry)
            
        } catch {
            NSLog("Error encoding entry representation: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error PUTTing entry")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    // DELETE ENTRY FROM SERVER
    func deleteEntryFromServer(entry: Entry, completion: @escaping Completionhandler = { _ in }) {
        
        guard let identifier = entry.identifier else {
            NSLog("No identifer for entry to delete")
            completion(NSError())
            return
        }
        
        let requestURL = EntryController.baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error DELETEing entry")
                completion(error)
                return
            }
        }.resume()
    }

    
}
