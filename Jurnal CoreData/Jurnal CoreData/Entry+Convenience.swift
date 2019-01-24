//
//  Entry+Convenience.swift
//  Jurnal CoreData
//
//  Created by Sergey Osipyan on 1/21/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    
    convenience init(title: String, bodyText: String, mood: String, identifier:  String, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.identifier = identifier
        self.timestamp = timestamp
        self.mood = mood
        
        
    }
    convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        guard let title = entryRepresentation.title,
       let bodyText = entryRepresentation.bodyText,
       let identifier = entryRepresentation.identifier,
       let timestamp = entryRepresentation.timestamp,
           let mood = entryRepresentation.mood else { return nil}
        
        self.init(title: title, bodyText: bodyText, mood: mood, identifier: identifier, timestamp: timestamp, context: context)
    }
    
}

