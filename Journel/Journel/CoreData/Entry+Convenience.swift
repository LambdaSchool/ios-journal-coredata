//
//  Entry+Convenience.swift
//  Journel
//
//  Created by Nathan Hedgeman on 8/22/19.
//  Copyright © 2019 Nate Hedgeman. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    convenience init(title: String, bodyText: String?, timeStamp: Date = Date(), identifier: UUID = UUID(), mood: String = "AIGHT", context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.mood = mood
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.identifier = identifier
    }
}
