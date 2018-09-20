//
//  EntryRepresentation.swift
//  Journal Core Data
//
//  Created by Dillon McElhinney on 9/19/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import Foundation

/// Represents an entry for decoding and comparison purposes
struct EntryRepresentation: Decodable, Equatable {
    
    var title: String
    var bodyText: String
    var mood: String
    var timestamp: Date
    var identifier: String
}

func == (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return lhs.identifier == rhs.identifier && lhs.title == rhs.title && lhs.bodyText == rhs.bodyText && lhs.mood == rhs.mood && lhs.timestamp == rhs.timestamp
}

func == (lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return rhs == lhs
}

func != (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return !(rhs == lhs)
}

func != (lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return rhs != lhs
}
