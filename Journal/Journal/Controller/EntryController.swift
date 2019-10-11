//
//  EntryController.swift
//  Journal
//
//  Created by Dillon P on 10/4/19.
//  Copyright © 2019 Lambda iOSPT2. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    private let baseURL = URL(string: "https://journal-dd383.firebaseio.com/")!
    
//    var entries: [Entry] {
//        loadFromPersistentStore()
//    }
    
    init() {
        fetchEntriesFromServer()
    }
    
//    func saveToPersistentStore() {
//        let moc = CoreDataStack.shared.mainContext
//
//        do {
//            try moc.save()
//        } catch {
//            print("Error saving data: \(error)")
//        }
//    }
    
    // MARK: - Put & Delete Entries
    
    func put(entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        
        guard let identifier = entry.identifier else {
            completion(nil)
            return
        }
        
        let baseWithIdentifierURL = baseURL.appendingPathComponent(identifier)
        let requestURL = baseWithIdentifierURL.appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        let jsonEncoder = JSONEncoder()
        
        do {
            CoreDataStack.shared.save()
            let data = try jsonEncoder.encode(entry.entryRepresentation)
            request.httpBody = data
        } catch {
            print("Error encoding the data: \(error)")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            
            if let error = error {
                print("General error: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
        
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        
        guard let identifier = entry.identifier else {
            completion(nil)
            return
        }
        
        let baseWithIdentifierURL = baseURL.appendingPathComponent(identifier)
        let requestURL = baseWithIdentifierURL.appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            
            if let error = error {
                print("Error deleting entry object: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            
        }.resume()
    }
    
    
    // MARK: - Syncing Databases
    
    // Set each of the Entry's values to the Entry Represenation's corresponding values
    func update(entry: Entry, entryRepresentation: EntryRepresentation) {
        entry.title = entryRepresentation.title
        entry.bodyText = entryRepresentation.bodyText
        entry.mood = entryRepresentation.mood
        entry.timestamp = entryRepresentation.timestamp
        entry.identifier = entryRepresentation.identifier
    }
    
    func updateEntries(with representations: [EntryRepresentation]) {
        
        let entryIdentifiers = representations.compactMap({ $0.identifier })
        var representationsByID = Dictionary(uniqueKeysWithValues: zip(entryIdentifiers, representations))
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", entryIdentifiers)
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        context.perform {
            do {
                let existingEntries = try context.fetch(fetchRequest)
                
                for entry in existingEntries {
                    guard let id = entry.identifier, let representaion = representationsByID[id] else {
                        continue
                    }
                    
                    self.update(entry: entry, entryRepresentation: representaion)
                    representationsByID.removeValue(forKey: id)
                }
                
                for representation in representationsByID.values {
                    let _ = Entry(entryRepresentation: representation, context: context)
                }
                
            } catch {
                print("Error fetching entries for identifiers: \(error)")
            }
        }
        
        CoreDataStack.shared.save(context: context)
    
    }
    
    func fetchEntriesFromServer(completion: @escaping (Error?) -> Void = { _ in })  {
        
        let requestURL = baseURL.appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                print("Error fetching entries: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            var entryRepresentations: [EntryRepresentation] = []
            
            let decoder = JSONDecoder()
            
            do {
                let entriesDictionary = try decoder.decode([String: EntryRepresentation].self, from: data)
                
                for entry in entriesDictionary {
                    entryRepresentations.append(entry.value)
                }
                
                self.updateEntries(with: entryRepresentations)
                completion(nil)
            } catch {
                print("Error decoding entry data: \(error)")
            }
            
        }.resume()
    }
    
    
    
    

    
    // MARK: - CRUD Entry Methods
    
    func createEntry(title: String, bodyText: String, mood: String) {
        if let moodRaw = Mood(rawValue: mood) {
            let entry = Entry(title: title, bodyText: bodyText, mood: moodRaw)
            put(entry: entry)
            
            CoreDataStack.shared.save()
            
        }
    }
    
    func updateEntry(title: String, bodyText: String, mood: String, entry: Entry) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood
        put(entry: entry)
        
        CoreDataStack.shared.save()
    }
    
    func deleteEntry(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        deleteEntryFromServer(entry: entry)
        
        CoreDataStack.shared.save()
    }
    
    //    func loadFromPersistentStore() -> [Entry] {
    //        let fetchedRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
    //
    //        let moc = CoreDataStack.shared.mainContext
    //
    //        do {
    //            return try moc.fetch(fetchedRequest)
    //        } catch {
    //            print("error fetching data: \(error)")
    //            return []
    //        }
    //    }
    
}
