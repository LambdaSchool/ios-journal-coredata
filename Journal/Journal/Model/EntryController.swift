//
//  EntryController.swift
//  Journal
//
//  Created by Jeremy Taylor on 8/13/18.
//  Copyright © 2018 Bytes-Random L.L.C. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    init() {
        fetchEntriesFromServer()
    }
    
    typealias CompletionHandler = (Error?) -> Void
    let baseURL = URL(string: "https://journal-coredata.firebaseio.com/")!
    
    func create(title: String, bodyText: String, mood: String) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood, context: CoreDataStack.shared.mainContext)
        put(entry: entry)
    }
    
    func update(entry: Entry, title: String, bodyText: String, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood
        
        put(entry: entry)
    }
    
    func update(entry: Entry, entryRep: EntryRepresentation) {
        entry.title = entryRep.title
        entry.bodyText = entryRep.bodyText
        entry.timestamp = entryRep.timestamp
        entry.mood = entryRep.mood
        
        put(entry: entry)
    }
    
    func delete(entry: Entry) {
        deleteEntryFromServer(entry: entry) { (error) in
            
                let moc = CoreDataStack.shared.mainContext
                moc.performAndWait {
                    moc.delete(entry)
                }
            
            }
    }
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let uuid = entry.identifier ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        do {
            request.httpBody = try JSONEncoder().encode(entry)
            
        } catch {
            NSLog("Error encoding json: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error PUTting data to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let uuid = entry.identifier ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error Deleting data on server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func fetchSingleEntryFromPersistentStore(identifier: String, context: NSManagedObjectContext) -> Entry? {
        var entry: Entry?
        context.performAndWait {
            
            let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
            do {
                entry = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error fetching task with uuid: \(identifier) \(error)")
            }
        }
        return entry
    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        let backgroundMoc = CoreDataStack.shared.container.newBackgroundContext()
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data from server: \(error)")
                completion(error)
                return
            }
            completion(nil)
            
            guard let data = data else {
                NSLog("No data returned")
                completion(NSError())
                return
            }
            
            do {
                var entryRepresentations: [EntryRepresentation] = []
                let data = try JSONDecoder().decode([String: EntryRepresentation].self, from: data)
                for data in data.values {
                    entryRepresentations.append(data)
                }
                
                self.updateEntries(with: entryRepresentations, context: backgroundMoc)
                
                completion(nil)
                try CoreDataStack.shared.save(context: backgroundMoc)
            } catch {
                NSLog("Error decoding data into json: \(error)")
            }
            
        }.resume()
        
    }
    
    private func updateEntries(with representations: [EntryRepresentation], context: NSManagedObjectContext) {
        context.performAndWait {
            for entryRep in representations {
                let entry = self.fetchSingleEntryFromPersistentStore(identifier: entryRep.identifier, context: context)
                
                if let entry = entry {
                    if entry == entryRep {
                        // Do nothing here
                    } else {
                        self.update(entry: entry, entryRep: entryRep)
                    }
                    
                } else {
                    let _ = Entry(entryRep: entryRep, context: context)
                    
                }
            }
        }
    }
}
