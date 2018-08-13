//
//  EntriesTableViewController.swift
//  Journal (Core Data)
//
//  Created by Linh Bouniol on 8/13/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    
    let entryController =  EntryController()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell

        // Set cell's entry to the entry at the specific indexPath
        cell.entry = entryController.entries[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Get the entry at the cell we want to delete
            let entry = entryController.entries[indexPath.row]
            
            // Get CoreDataStack's mainContext, call .delete()
            let moc = CoreDataStack.shared.mainContext
            moc.delete(entry)
            
            // Save the deletion
            do {
                try moc.save()
            } catch {
                // If saving the deletion failed, discard any changes
                moc.reset()
            }
            
            tableView.reloadData()
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEntryDetail" {
            let detailVC = segue.destination as! EntryDetailViewController
            
            // Get indexPath of selected cell
            if let indexPath = tableView.indexPathForSelectedRow?.row {
                // Setting the entry at that indexPath to the detailVC's entry property
                detailVC.entry = entryController.entries[indexPath]
            }
        }
        
        // Don't need to do anything for the other segue
    }
}
