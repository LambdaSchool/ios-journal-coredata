//
//  Entry+Convenience.swift
//  Journal Core Data
//
//  Created by Dillon McElhinney on 9/17/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import Foundation
import CoreData

enum Moods: String, CaseIterable {
    case 😔
    case 😐
    case 🙂
}

extension Entry {
    /// Convenience initializer to assign the properties of an Entry, in addition to adding it to a NSManagedObjectContext.
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), identifier: String = UUID().uuidString, mood: String = Moods.😐.rawValue, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood
    }
    
    /// Convenience initializer for initializing from an Entry Representation
    convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  timestamp: entryRepresentation.timestamp,
                  identifier: entryRepresentation.identifier,
                  mood: entryRepresentation.mood,
                  context: context)
    }
    
    /// Computed property that returns a formatted timestamp.
    var formattedTimestamp: String {
        return Entry.dateFormatter.string(from: timestamp ?? Date())
    }
    
    /// Static property that holds the date formatter.
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
}
