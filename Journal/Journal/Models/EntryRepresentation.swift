//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Hector Steven on 5/29/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
	var identifier: String
	var title: String
	var mood: String
	var bodyText: String?
	var timeStamp: Date
}
