//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Lambda_School_Loaner_259 on 3/25/20.
//  Copyright © 2020 DeVitoC. All rights reserved.
//

import Foundation
import CoreData

struct EntryRepresentation: Codable {
    var identifier: String?
    var title: String
    var bodyText: String
    var timestamp: Date
    var mood: String?
}
