//
//  Entry+Convenience.swift
//  Journal (Core Data)
//
//  Created by Sammy Alvarado on 8/5/20.
//  Copyright © 2020 Sammy Alvarado. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    @discardableResult convenience init(identifier: UUID = UUID(),
                                        bodyText: String,
                                        title: String,
                                        timestamp: Date,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext
                                        ) {
        self.init(context: context)
        self.identifier = identifier
        self.bodyText = bodyText
        self.title = title
        self.timestamp = timestamp
    }
}



