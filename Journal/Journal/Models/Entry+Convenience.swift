//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Chris Dobek on 4/20/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String, CaseIterable {
    case sad = "😢"
    case neutral = "😐"
    case happy = "☺️"
}

extension Entry {
    
    var journalRepresentation: JournalRepresentation? {
        guard let id = identifier,
        let title = title,
            let mood = mood else {
                return nil
        }
        
        return JournalRepresentation(identifier: id.uuidString,
                                     title: title,
                                     bodyText: bodyText,
                                     mood: mood,
                                     timestamp: Date())
    }
    
    @discardableResult convenience init(title: String,
                                        bodyText: String? = nil,
                                        timestamp: Date = Date(),
                                        identifier: UUID = UUID(),
                                        mood: EntryMood = .neutral,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
        
    }
    @discardableResult convenience init?(journalRepresentation: JournalRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let mood = EntryMood(rawValue: journalRepresentation.mood),
            let identifier = UUID(uuidString: journalRepresentation.identifier) else {
                return nil
        }
        
        self.init(title: journalRepresentation.title,
                  bodyText: journalRepresentation.bodyText,
                  timestamp: journalRepresentation.timestamp,
                  identifier: identifier,
                  mood: mood,
                  context: context)
    }
}
