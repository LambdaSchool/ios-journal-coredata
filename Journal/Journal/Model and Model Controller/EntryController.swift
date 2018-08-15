//
//  EntryController.swift
//  Journal
//
//  Created by Andrew Liao on 8/13/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import Foundation
import CoreData

enum MoodType:String {
    case sad = "🙁"
    case neutral = "😐"
    case happy = "🙂"
    
    static var types = [sad, neutral,happy]
}

private let baseURL = URL(string: "https://journal-day-3.firebaseio.com/")!

class EntryController{
    //MARK: - CRUD Methods
    func create(withTitle title: String, bodyText text:String? = nil, mood:String){
        let newEntry = Entry(title: title, bodyText: text, mood:mood)
        put(entry: newEntry) { (error) in
            if let error = error {
                NSLog("Error creating and putting entry: \(error)")
                CoreDataStack.shared.mainContext.reset()
            }
        self.saveToPersistentStore()
        }
        
    }
    
    func update(forEntry entry: Entry, withTitle title: String, bodyText text:String, mood: String){
        entry.title = title
        entry.bodyText = text
        entry.timeStamp = Date()
        entry.mood = mood
        put(entry: entry) { (error) in
            if let error = error {
                NSLog("Error updating and putting entry: \(error)")
                CoreDataStack.shared.mainContext.reset()
            }
            self.saveToPersistentStore()
        }
    }
    
    func delete(entry: Entry){
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        deleteEntryFromServer(entry: entry){ (error) in
            if let error = error {
                NSLog("Error updating and putting entry: \(error)")
                CoreDataStack.shared.mainContext.reset()
            }
            self.saveToPersistentStore()
        }
    }
    //MARK: - Persistence
    func saveToPersistentStore(){
        let moc = CoreDataStack.shared.mainContext
        do{
            try moc.save()
        } catch {
            NSLog("Trouble saving: \(error)")
            moc.reset()
        }
    }
    
    //MARK: - Networking
    typealias CompletionHandler = (Error?) -> Void
    
    func put(entry: Entry, completion: @escaping CompletionHandler = {_ in}) {
        let url = baseURL
            .appendingPathComponent(entry.identifier!)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        do {
            let encoded = try JSONEncoder().encode(entry)
            request.httpBody = encoded
        } catch {
            NSLog("Error encoding: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error PUTting: \(error)")
            }
            completion(nil)
            
        }.resume()
    }
    
    func deleteEntryFromServer(entry:Entry, completion: @escaping CompletionHandler = {_ in}){
        let url = baseURL
            .appendingPathComponent(entry.identifier!)
            .appendingPathExtension("json")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error deleting from server: \(error)")
                return
            }
            completion(nil)
        }.resume()
        
    }

}
