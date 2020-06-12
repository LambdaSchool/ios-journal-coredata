//
//  EntryController.swift
//  journal-coredata
//
//  Created by Rob Vance on 6/9/20.
//  Copyright © 2020 Robs Creations. All rights reserved.
//


import Foundation
import CoreData

enum NetworkError: Error {
    case noIdentifier
    case otherError
    case noData
    case noDecode
    case noEncode
    case noRep
}




let baseURL = URL(string: "https://coredata3-dc2ab.firebaseio.com/")!

class EntryController {
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void

    init() {
        fetchEntriesFromServer()
    }

    func sendEntryToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }

        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")

        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"

        do {
            guard let representation = entry.entryRepresentation else {
                completion(.failure(.noRep))
                return
            }

            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding entry \(entry): \(error)")
            completion(.failure(.noEncode))
            return
        }

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error Putting entry to server: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                    return
                }
            }

            DispatchQueue.main.async {
                completion(.success(true))
            }
        }.resume()
    }

    func deleteEntryFromServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }

        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(response!)
            completion(.success(true))
        }.resume()
    }

    private func update(entry: Entry, with representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood
        entry.timestamp = representation.timestamp
    }

    private func updateEntries(with representations: [EntryRepresentation]) throws {

        let context = CoreDataStack.shared.container.newBackgroundContext()

        let identifiersToFetch = representations.compactMap({ UUID(uuidString: $0.identifier )})

        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var entriesToCreate = representationsByID

        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)

        context.perform {
            do {
                let existingEntries = try context.fetch(fetchRequest)

                for entry in existingEntries {
                    guard let id = entry.identifier,
                        let representation = representationsByID[id] else { continue }

                    self.update(entry: entry, with: representation)
                    entriesToCreate.removeValue(forKey: id)
                }

                for representation in entriesToCreate.values {
                    Entry(entryRepresentation: representation, context: context)
                }
            } catch {
                print("Error fetching entries for UUIDs: \(error)")
            }

            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                print("There's an error!")
            }
        }
    }

    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")

        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                print("Error fetching entries: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }

            guard let data = data else {
                print("No data returned by data task")
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }

            do {
                let entryRepresentations = Array(try JSONDecoder().decode([String : EntryRepresentation].self, from: data).values)

                try self.updateEntries(with: entryRepresentations)
                DispatchQueue.main.async {
                    completion(.success(true))
                }
            } catch {
                print("Error decoding entry representations: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.noDecode))
                }
                return
            }
        }.resume()
    }
}

