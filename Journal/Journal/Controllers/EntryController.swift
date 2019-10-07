//
//  EntryController.swift
//  Journal
//
//  Created by Jessie Ann Griffin on 10/2/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    private let moc = CoreDataStack.shared.mainContext
    
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
    }
    
    func update(title: String, bodyText: String?, entry: Entry, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timeStamp = Date()
        entry.mood = mood
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        moc.delete(entry)
        saveToPersistentStore()
    }
}
