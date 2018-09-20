//
//  EntryController.swift
//  Journal Core Data
//
//  Created by Dillon McElhinney on 9/17/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // MARK: - Properties
    /// Holds the base URL for the API
    let baseURL = URL(string: "https://core-data-journal.firebaseio.com/")!
    
    // MARK - Initializers
    init() {
        fetchEntriesFromServer()
    }
    
    // MARK: - CRUD Methods
    /// Creates a new entry with the given properties in the local persistent store and the server
    func createEntry(title: String, bodyText: String, mood: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        
        do {
            try CoreDataStack.shared.save(context: context)
            put(entry)
        } catch {
            NSLog("Error creating new entry: \(error)")
        }
    }
    
    /// Updates the given entry with the given properties in the local persistent store and the server
    func update(entry: Entry, title: String, bodyText: String, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        
        put(entry)
    }
    
    func update(entry: Entry) {
        put(entry)
    }
    
    /// Updates the given entry with the properties of the given entry representation
    private func update(entry: Entry, entryRepresentation: EntryRepresentation) {
        entry.title = entryRepresentation.title
        entry.timestamp = entryRepresentation.timestamp
        entry.bodyText = entryRepresentation.bodyText
        entry.mood = entryRepresentation.mood
        entry.identifier = entryRepresentation.identifier
    }
    
    /// Deletes the given entry from the server and the local persistent store
    func delete(entry: Entry) {
        deleteEntryFromServer(entry)
        
        CoreDataStack.shared.mainContext.performAndWait {
            CoreDataStack.shared.mainContext.delete(entry)
        }
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error deleting entry.")
            CoreDataStack.shared.mainContext.reset()
        }
    }
    
    // MARK: - Persistence
    /// Returns an optional Entry that matches the given identifier
    private func fetchSingleEntryFromPersistentStore(identifier: String, context: NSManagedObjectContext) -> Entry? {
        // Make a request
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        // Make a predicate
        let predicate = NSPredicate(format: "identifier = %@", identifier)
        
        // Set the request's predicate
        fetchRequest.predicate = predicate
        
        // Make a variable to hold the entry to return
        var entry: Entry? = nil
        
        context.performAndWait {
            do {
                // Try to fetch an Entry and return the first one if it exists
                entry = try context.fetch(fetchRequest).first
            } catch {
                // Handle any errors with the fetch
                NSLog("Error fetching single entry from persistent store: \(error)")
            }
        }
        
        return entry
    }
    
    // MARK: - Networking
    /// Fetches all existing entries from the server, creates local versions of any that don't exist and updates local versions that are different.
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        // Make request URL
        let requestURL = baseURL.appendingPathExtension("json")
        
        // Start a GET data task on the shared URL Sesssion
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            // Handle any errors with the GET request
            if let error = error {
                NSLog("Error fetching entries from server: \(error)")
                completion(error)
                return
            }
            
            // Unwrap the returned data
            guard let data = data else {
                NSLog("No data returned from fetching entries from server.")
                completion(NSError())
                return
            }
            
            // Instantiate an array to hold the representations
            var entryRepresentations: [EntryRepresentation] = []
            
            do {
                // Try to decode the data into a dictionary and the map that dictionary to the array of representations
                entryRepresentations = try JSONDecoder().decode([String: EntryRepresentation].self, from: data).map() { $0.value }
                
                // Create a new background context sense we are on a background queue
                let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
                
                backgroundContext.performAndWait {
                    // Load the background context with the entries fetched from the server
                    self.updateContextWithEntryRepresentations(context: backgroundContext, entryRepresentations: entryRepresentations)
                }
                
                // Save everything to the persistent store
                do {
                    try CoreDataStack.shared.save(context: backgroundContext)
                } catch {
                    // Handle any errors with saving
                    NSLog("Error saving entries to background context: \(error)")
                    completion(error)
                    return
                }
                completion(nil)
                return
            } catch {
                // Handle any errors with decoding
                NSLog("Error decoding fetched entry representations: \(error)")
                completion(error)
                return
            }
            
        }.resume()
    }
    
    /// PUTs the given entry to the server
    private func put(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        
        // Unwrap the identifier
        let identifier = entry.identifier ?? UUID().uuidString
        
        entry.identifier = identifier
        do {
            let context = entry.managedObjectContext ?? CoreDataStack.shared.mainContext
            try CoreDataStack.shared.save(context: context)
        } catch {
            NSLog("Error saving updated entry: \(error)")
        }
        
        // Make the request URL
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        
        // Make the request and set its HTTP Method
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            // Try to encode the entry and assign it to the request's body
            request.httpBody = try JSONEncoder().encode(entry)
        } catch {
            // Handle any errors with encoding
            NSLog("Error encoding entry: \(error)")
            completion(error)
            return
        }
        
        // Start a PUT data task on the shared URL Session
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            // Handle any errors with the PUT request
            if let error = error {
                NSLog("Error PUTting entry: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    /// DELETEs the given entry from the server
    private func deleteEntryFromServer (_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        // Unwrap the identifier
        guard let identifier = entry.identifier else {
            NSLog("No identifier to delete enty by.")
            completion(NSError())
            return
        }
        
        // Make the request URL
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        
        // Make request and set its HTTP Method
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        // Start a DELETE data task on the shared URL Session
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            // Handle any errors with the DELETE request
            if let error = error {
                NSLog("Error DELETEing entry from server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            return
        }.resume()
        
    }
    
    // MARK: - Utility Methods
    /// Updates the given context with the given entry representations, creating them where they don't exist and updating them where necessary.
    private func updateContextWithEntryRepresentations(context: NSManagedObjectContext = CoreDataStack.shared.mainContext, entryRepresentations: [EntryRepresentation]) {
        // Loop through each representation to see if a corresponding entry already exists
        for entryRepresentation in entryRepresentations {
            if let entry = self.fetchSingleEntryFromPersistentStore(identifier: entryRepresentation.identifier, context: context) {
                // If it does, check to see if the properties are all the same.
                if entry != entryRepresentation {
                    // If not, update the entry in our context
                    self.update(entry: entry, entryRepresentation: entryRepresentation)
                }
            } else {
                // If not, create a new entry
                _ = Entry(entryRepresentation: entryRepresentation, context: context)
            }
        }
    }
}
