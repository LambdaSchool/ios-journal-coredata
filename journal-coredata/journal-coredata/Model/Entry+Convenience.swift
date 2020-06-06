//
//  Entry+Convenience.swift
//  journal-coredata
//
//  Created by Rob Vance on 6/2/20.
//  Copyright © 2020 Robs Creations. All rights reserved.
//

import Foundation
import CoreData

enum MoodPriority: String, CaseIterable {
    case 😃
    case 🙁
    case 😐
}

extension Entry {
    @discardableResult convenience init(title: String?,
                                        bodyText: String? = nil,
                                        timestamp: Date = Date(),
                                        identifier: UUID = UUID(),
                                        mood: MoodPriority = .😐,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
}
