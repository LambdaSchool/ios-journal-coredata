//
//  EntryController.swift
//  Journal
//
//  Created by Jason Modisett on 9/17/18.
//  Copyright © 2018 Jason Modisett. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // Create a new entry in the managed object context and save it to persistent store
    func createEntry(with title: String, bodyText: String?, mood: Mood, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood, context: context)
        
        do {
            try CoreDataStack.shared.save(context: context)
        } catch {
            NSLog("Error saving entry: \(error)")
        }
        put(entry: entry)
    }
    
    // Update an existing entry in the managed object context, and save it to persistent store
    func update(entry: Entry, with title: String, bodyText: String?, mood: Mood) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood.rawValue
        entry.timestamp = Date()
        
        put(entry: entry)
    }
    
    // Delete an entry in the managed object context and save the new managed object content
    // to persistent store
    func delete(entry: Entry) {
        
        deleteEntryFromServer(entry: entry)
        
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        
        do {
            try CoreDataStack.shared.save(context: moc)
        } catch {
            moc.reset()
            NSLog("Error saving moc after deleting entry: \(error)")
        }
    }
    
    func entry(for identifier: String, in context: NSManagedObjectContext) -> Entry? {
        guard let identifier = UUID(uuidString: identifier) else { return nil }
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        let predicate = NSPredicate(format: "identifier == %@", identifier as NSUUID)
        fetchRequest.predicate = predicate
        
        var result: Entry? = nil
        
        context.performAndWait {
            do {
                result = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error fetching entry with UUID: \(identifier): \(error)")
            }
        }
        
        return result
    }
    
}


// Networking
extension EntryController {
    
    typealias CompletionHandler = (Error?) -> Void
    
    func fetchEntrysFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = EntryController.baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching entries: \(error)")
                completion(error)
            }
            
            guard let data = data else {
                NSLog("No data returned from data entry.")
                completion(NSError())
                return
            }
            
            do {
                let entryRepresentations = try JSONDecoder().decode([String: EntryRepresentation].self, from: data).map({ $0.value })
                
                let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
                
                backgroundContext.performAndWait {
                
                    for entryRep in entryRepresentations {
                        
                        if let entry = self.entry(for: entryRep.identifier, in: backgroundContext) {
                            guard let mood = Mood(rawValue: entryRep.mood) else { return }
                            self.update(entry: entry, with: entryRep.title, bodyText: entryRep.bodyText, mood: mood)
                        } else {
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
                NSLog("Error decoding Entry representations: \(error)")
                completion(error)
                return
            }
            
            }.resume()
    }
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        
        let identifer = entry.identifier ?? UUID()
        
        let requestURL = EntryController.baseURL.appendingPathComponent(identifer.uuidString).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var entryRepresentation = entry.entryRepresentation else {
                completion(NSError())
                return
            }
            
            entryRepresentation.identifier = identifer.uuidString
            entry.identifier = identifer
            
            try CoreDataStack.shared.save()
            
            request.httpBody = try JSONEncoder().encode(entryRepresentation)
            
        } catch {
            NSLog("Error encoding Entry representation: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error PUTing Entry: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            
            }.resume()
        
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier else {
            NSLog("No identifier for Entry to delete")
            completion(NSError())
            return
        }
        
        let requestURL = EntryController.baseURL.appendingPathComponent(identifier.uuidString).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(response!)
            completion(error)
            }.resume()
    }
    
    
    static let baseURL = URL(string: "https://journal-jason-modisett.firebaseio.com/")!
}
