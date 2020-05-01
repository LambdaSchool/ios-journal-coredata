//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Thomas Dye on 4/30/20.
//  Copyright © 2020 Thomas Dye. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var identifier: String
    var title: String
    var bodyText: String
    var timestamp: Date
    var mood: String
}
