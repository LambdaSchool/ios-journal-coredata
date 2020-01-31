//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Jorge Alvarez on 1/27/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String {
    case sad
    case neutral
    case happy
    
    static var allMoods: [Mood] {
        return [.sad, .neutral, .happy]
    }
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title, let mood = mood, let bodyText = bodyText else {return nil}
        
        return EntryRepresentation(title: title, bodyText: bodyText, mood: mood, timestamp: timestamp!, identifier: identifier)
    }
    
    convenience init(title: String,
                     bodyText: String,
                     timestamp: Date = Date(),
                     identifier: String = UUID().uuidString,
                     mood: Mood = .neutral,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        guard let mood = Mood(rawValue: entryRepresentation.mood!), let identifierString = entryRepresentation.identifier else {return nil}
        
        self.init(title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  identifier: identifierString,
                  mood: mood,
                  context: context)
    }
}
