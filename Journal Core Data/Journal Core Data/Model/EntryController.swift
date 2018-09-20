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
    func createEntry(title: String, bodyText: String, mood: String) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        
        saveToPersistentStore()
        put(entry)
    }
    
    /// Updates the given entry with the given properties in the local persistent store and the server
    func update(entry: Entry, title: String, bodyText: String, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        
        saveToPersistentStore()
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
        
        CoreDataStack.shared.mainContext.delete(entry)
        
        saveToPersistentStore()
    }
    
    // MARK: - Persistence
    /// Saves the main context to the persistent store
    private func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context to persistent store: \(error)")
        }
    }
    
    /// Returns an optional Entry that matches the given identifier
    private func fetchSingleEntryFromPersistentStore(identifier: String) -> Entry? {
        // Make a request
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        // Make a predicate
        let predicate = NSPredicate(format: "identifier = %@", identifier)
        
        // Set the request's predicate
        fetchRequest.predicate = predicate
        
        do {
            // Try to fetch an Entry and return the first one if it exists
            return try CoreDataStack.shared.mainContext.fetch(fetchRequest).first
        } catch {
            // Handle any errors with the fetch and return nil
            NSLog("Error fetching single entry from persistent store: \(error)")
            return nil
        }
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
                
                // Loop through each representation to see if a corresponding entry already exists
                for entryRepresentation in entryRepresentations {
                    if let entry = self.fetchSingleEntryFromPersistentStore(identifier: entryRepresentation.identifier) {
                        // If it does, check to see if the properties are all the same.
                        if entry != entryRepresentation {
                            // If not, update the entry in our context
                            self.update(entry: entry, entryRepresentation: entryRepresentation)
                        }
                    } else {
                        // If not, create a new entry
                        _ = Entry(entryRepresentation: entryRepresentation)
                        
                    }
                }
                
                // Save everything to the persistent store
                self.saveToPersistentStore()
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
        
        // If there isn't one, set it and update the persistent store
        if entry.identifier != identifier {
            entry.identifier = identifier
            saveToPersistentStore()
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
}
