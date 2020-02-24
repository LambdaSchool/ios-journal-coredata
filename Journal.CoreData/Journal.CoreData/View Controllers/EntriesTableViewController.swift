//
//  EntriesTableViewController.swift
//  Journal.CoreData
//
//  Created by beth on 2/24/20.
//  Copyright © 2020 elizabeth wingate. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
  let entryController = EntryController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
              super.viewWillAppear(animated)

        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }

   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }

        let entry = entryController.entries[indexPath.row]
        cell.entry = entry
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            entryController.delete(for: entryController.entries[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "AddEntrysSegue" {
              if let detailVC = segue.destination as? EntryDetailViewController {
                  detailVC.entryController = self.entryController
              }
          } else if segue.identifier == "ExistingEntrySegue" {
              if let detailVC = segue.destination as? EntryDetailViewController,
                  let indexPath = tableView.indexPathForSelectedRow {
                  detailVC.entryController = self.entryController
                  detailVC.entry = self.entryController.entries[indexPath.row]
              }
          }
      }
}
