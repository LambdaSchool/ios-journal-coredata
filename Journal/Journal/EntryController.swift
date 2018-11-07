//
//  EntryController.swift
//  Journal
//
//  Created by Yvette Zhukovsky on 11/5/18.
//  Copyright © 2018 Yvette Zhukovsky. All rights reserved.
//

import Foundation
import CoreData


//let baseURL = URL(string: "https://journal-a6662.firebaseio.com/")!

class EntryController {
    
    
    typealias CompletionHandler = (Error?) -> Void
    
    static let baseURL = URL(string: "https://journal-a6662.firebaseio.com/")!
    
    func put(entry: Entry, completion: @escaping CompletionHandler = {_ in}) {
        let identifier = entry.identifier ?? UUID().uuidString
        
        let requestURL = EntryController.baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url:requestURL)
        
        request.httpMethod = "PUT"
        
        do {
            request.httpBody = try JSONEncoder().encode(entry)
            
            
        }
        catch {
            NSLog("error encoding:\(error)")
            completion(error)
            return
            
        }
        
        URLSession.shared.dataTask(with: request) {(data, _, error) in
            
            if let error = error {
                NSLog("Error PUTing entry:\(error)")
                completion(error)
                return
            }
            completion(nil)
            }.resume()
    }
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = {_ in}){
        guard let identifier = entry.identifier else {
            
            NSLog("no identifieer found")
            completion(NSError())
            return
        }
        
        let requestURL = EntryController.baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url:requestURL)
        
        request.httpMethod = "DELETE"
        
        
        URLSession.shared.dataTask(with: request) {(data, _, error) in
            
            if let error = error {
                NSLog("Error deleting entry:\(error)")
                completion(error)
                return
            }
            
            }.resume()
    }
    
    func saveToPersistentStore(){
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        }
        catch {
            NSLog("Error saving \(error)")
        }
    }
    
    
    func Create(title: String, bodytext: String, mood: Mood ){
        
        let entry = Entry(title: title, bodytext: bodytext, mood: mood)
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func Update(entry: Entry, title: String, bodytext: String, mood: Mood ) {
        entry.title = title
        entry.bodytext = bodytext
        entry.timestamp = Date()
        entry.mood = mood.rawValue
        saveToPersistentStore()
        put(entry: entry)
    }
    func Delete(entry: Entry){
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
        
        deleteEntryFromServer(entry: entry)
        
    }
    
    
    func update(entry: Entry, entryRepresentation: EntryRepresentation){
        entry.title = entryRepresentation.title
        entry.bodytext = entryRepresentation.bodytext
        entry.mood = entryRepresentation.mood
        entry.timestamp = entryRepresentation.timestamp
        entry.identifier = entryRepresentation.identifier
        
    }
    
    
    
    func fetchSingleEntryFromPersistentStore(identifier: String) -> Entry? {
        guard let identifier = UUID(uuidString: identifier) else {return nil}
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier as NSUUID)
        let moc = CoreDataStack.shared.mainContext
        return (try? moc.fetch(fetchRequest))?.first
        
    }
    
    
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = {_ in }) {
        
        let requestURL = EntryController.baseURL.appendingPathExtension("json")
        URLSession.shared.dataTask(with: requestURL) {(data, _, error) in
         if let error = error {
                NSLog("error fetching error:\(data)")
                completion(error)
                return
            }
            guard let data = data else {
                NSLog("No data returned by data ")
                completion(NSError())
                return
                }
            var entryRepresentations: [EntryRepresentation] = []
            DispatchQueue.main.async {
                
                do {
                    let journalRepresentationDict = try JSONDecoder().decode([String:EntryRepresentation].self, from: data)
                    
                } catch {
                    
                    NSLog("Error decoding:\(error)")
                    completion(error)
                    return
                }
                for entriesRep in entryRepresentations {
                let entry = self.fetchSingleEntryFromPersistentStore(identifier: entriesRep.identifier )
                    if let entry = entry, entry != entriesRep {
                        self.update(entry: entry, entryRepresentation: entriesRep )
                    } else if entry == nil {
                        //We neeed to create a new task in Core Data
                        let _ = Entry(entryRepresentation: entriesRep)
                        
                    }
                }
                }
        }.resume()
    }
    
    //                        let moc = CoreDataStack.shared.mainContext
    //                        try moc.save()
    //
    
    
    //let entryRepresentations = Array(journalRepresentationDict.values)
    
    var entries: [Entry] = []
    //    {
    //
    //        return loadFromPersistentStore()
    //    }
    
}
