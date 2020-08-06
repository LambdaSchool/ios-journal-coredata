//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Cora Jacobson on 8/5/20.
//  Copyright © 2020 Cora Jacobson. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {

    // MARK: - Properties

    var entries: [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let context = CoreDataStack.shared.mainContext
        do {
            return try context.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return []
        }
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }

    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EntryTableViewCell.reuseIdentifier, for: indexPath) as? EntryTableViewCell else {
            fatalError("Can't dequeue cell of type \(EntryTableViewCell.reuseIdentifier)")
        }
        cell.entry = entries[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entries[indexPath.row]
            let moc = CoreDataStack.shared.mainContext
            moc.delete(entry)
            do {
                try moc.save()
                tableView.reloadData()
            } catch {
                moc.reset()
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
