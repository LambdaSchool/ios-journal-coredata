//
//  EntriesTableViewController.swift
//  Journal Core Data
//
//  Created by Niranjan Kumar on 11/11/19.
//  Copyright © 2019 Nar Kumar. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {

    var entryController = EntryController()
    
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


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entryController.entries[indexPath.row]
            entryController.delete(entry: entry)
            tableView.reloadData()
        }
    }


    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddSegue" {
            if let addVC = segue.destination as? EntryDetailViewController {
                addVC.entryController = entryController
            }
        } else if segue.identifier == "DetailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow,
                let detailVC = segue.destination as? EntryDetailViewController {
                detailVC.entry = entryController.entries[indexPath.row]
                detailVC.entryController = entryController
            }
        }
    }
}
 
