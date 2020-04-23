//
//  EntryRepresentation.swift
//  Journal - CoreData
//
//  Created by Nichole Davidson on 4/22/20.
//  Copyright © 2020 Nichole Davidson. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var identifier: String
    var title: String
    var timestamp: Date
    var bodyText: String
    var mood: String
}
