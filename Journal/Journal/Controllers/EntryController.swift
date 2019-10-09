//
//  EntryController.swift
//  Journal
//
//  Created by Jessie Ann Griffin on 10/2/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case host = "HOST"
    case delete = "DELETE"
}

class EntryController {
    
    let baseURL = URL(string: "https://lambdajournalforcoredata.firebaseio.com/")
    
    private let moc = CoreDataStack.shared.mainContext
    
    func put(entry: EntryRepresentation, completion: @escaping (Error?) -> Void = { _ in }) {
        
        guard let baseURL = baseURL, let identifier = entry.identifier else { return }
        
        let idURL = baseURL.appendingPathComponent(identifier)
        let requestURL = idURL.appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(entry)
            request.httpBody = data
        } catch {
            print("Error encoding data: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error fetching entries: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                print("No data was returned by the data task")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let _ = try decoder.decode(EntryRepresentation.self, from: data)
                completion(nil)
            } catch {
                print("Error decoding entry representations: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    
    // MARK: METHODS FOR SAVING AND LOADING DATA
    private func saveToPersistentStore() {
        
        do {
            try moc.save()
        } catch {
            moc.reset()
            print("Error saving managed object context: \(error)")
        }
    }
    
    func create(title: String, bodyText: String?, timeStamp: Date, identifier: String, mood: String) {
        let _ = Entry(title: title, bodyText: bodyText, timeStamp: timeStamp, identifier: identifier, mood: mood)
        saveToPersistentStore()
        put(entry: EntryRepresentation(title: title, bodyText: bodyText, timeStamp: timeStamp, mood: mood, identifier: identifier))
    }
    
    func update(title: String, bodyText: String?, entry: Entry, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timeStamp = Date()
        entry.mood = mood
        saveToPersistentStore()
        guard let timeStamp = entry.timeStamp else { return }
        put(entry: EntryRepresentation(title: title, bodyText: bodyText, timeStamp: timeStamp, mood: mood, identifier: entry.identifier))
    }
    
    func delete(entry: Entry) {
        moc.delete(entry)
        saveToPersistentStore()
    }
}
