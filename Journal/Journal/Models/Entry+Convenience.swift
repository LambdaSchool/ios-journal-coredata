//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Kelson Hartle on 5/17/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import Foundation
import CoreData

    enum Mood: String, CaseIterable {
        case sad = "☹️"
        case ok = "😐"
        case happy = "😄"


    }

extension Entry {
    @discardableResult convenience init(identifier: String = String(),
                                        bodyText: String,
                                        timeStamp: Date = Date(),
                                        title: String,
                                        mood: Mood = .ok,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.identifier = identifier
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.title = title
        self.mood = mood.rawValue
        
    }
}
