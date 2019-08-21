//
//  EntryController.swift
//  Journal-CoreData
//
//  Created by Marlon Raskin on 8/19/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation
import CoreData

class EntryController {

	let baseURL = URL(string: "https://journal-797ea.firebaseio.com/")!

	func createEntry(title: String, bodyText: String, mood: Mood) {
		let entry = Entry(title: title, bodyText: bodyText, mood: mood)
		saveToPersistentStore()
		put(entry: entry)
	}

	func updateEntry(entry: Entry, title: String, bodyText: String, date: Date = Date(), mood: Mood) {
		put(entry: entry)
		entry.title = title
		entry.bodyText = bodyText
		entry.timeStamp = date
		entry.mood = mood.rawValue
		saveToPersistentStore()
	}

	func deleteEntry(entry: Entry) {
		let moc = CoreDataStack.shared.mainContext
		moc.delete(entry)
		saveToPersistentStore()
		deleteEntryFromServer(entry: entry)
	}

	func loadFromPersistentStore() -> [Entry] {
		let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
		let moc = CoreDataStack.shared.mainContext

		do {
			let entries = try moc.fetch(fetchRequest)
			return entries
		} catch {
			NSLog("Error fetching Entries: \(error)")
			return []
		}
	}

	func saveToPersistentStore() {
		let moc = CoreDataStack.shared.mainContext

		do {
			try moc.save()
		} catch {
			NSLog("Error saving moc: \(error)")
			moc.reset()
		}
	}
}


extension EntryController {

	func put(entry: Entry, completion: @escaping(Error?) -> Void = { _ in }) {
		let requestURL = baseURL.appendingPathExtension("json")
		var request = URLRequest(url: requestURL)
		request.httpMethod = HTTPMethod.put.rawValue

		do {
			let entryData = try JSONEncoder().encode(entry.entryRepresentation)
			request.httpBody = entryData
		} catch {
			NSLog("Error encoding entry representation: \(error)")
			completion(error)
			return
		}

		URLSession.shared.dataTask(with: request) { (_, _, error) in
			if let error = error {
				NSLog("Error PUTing entry representation to server: \(error)")
			}
			completion(nil)
		}.resume()

	}

	func deleteEntryFromServer(entry: Entry, completion: @escaping(Error?) -> Void = { _ in }) {
		guard let identifier = entry.identifier else {
			completion(nil)
			return
		}

		let requestURL = baseURL
			.appendingPathComponent(identifier.uuidString)
			.appendingPathExtension("json")
		var request = URLRequest(url: requestURL)
		request.httpMethod = HTTPMethod.delete.rawValue

		URLSession.shared.dataTask(with: request) { (_, _, error) in
			if let error = error {
				NSLog("Error deleting task: \(error)")
			}
			completion(nil)
		}.resume()
	}
}

enum HTTPMethod: String {
	case get = "GET"
	case put = "PUT"
	case post = "POST"
	case delete = "DELETE"
}
