//
//  Task+Convenience.swift
//  Tasks
//
//  Created by Simon Elhoej Steinmejer on 13/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String
{
    case unhappy = "🙁"
    case neutral = "😐"
    case happy = "😁"
    
    static var allMoods: [Mood]
    {
        return [.unhappy, .neutral, .happy]
    }
}

extension Entry
{
    convenience init(title: String, bodyText: String? = nil, timestamp: Date? = Date(), identifier: String? = UUID().uuidString, mood: String = "😐", managedObjectContext: NSManagedObjectContext = CoreDataStack.shared.mainContext)
    {
        self.init(context: managedObjectContext)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood
    }
    
    convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext)
    {
        self.init(title: entryRepresentation.title, bodyText: entryRepresentation.bodyText, timestamp: entryRepresentation.timestamp, identifier: entryRepresentation.identifier, mood: entryRepresentation.mood)
    }
    
    
}









