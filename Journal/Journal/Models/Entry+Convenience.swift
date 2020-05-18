//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Nonye on 5/18/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    @discardableResult convenience init(indentifier: String = String(),
                                        title: String,
                                        bodyText: String,
                                        timeStamp: Date,
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
    }
}
    


//extension Task {
//    //give these default values
//    @discardableResult convenience init(indentifier: UUID = UUID(),
//                     name: String,
//                     notes: String? = nil,
//                     complete: Bool = false,
//                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
//        self.init(context: context)
//        self.identifier = identifier
//        self.name = name
//        self.notes = notes
//        self.complete = complete
//    }
//}

