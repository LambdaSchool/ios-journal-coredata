//
//  EntriesTableViewController.swift
//  Journal Core Data
//
//  Created by Austin Cole on 1/14/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    let entryController = EntryController()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else {fatalError("Could not DQ cell.")}
//        cell.entry = entryController.entries[indexPath.row]
        cell.titleLabel.text = entryController.entries[indexPath.row].title
        cell.detailLabel.text = entryController.entries[indexPath.row].bodyText
        cell.timestampLabel.text = DateFormatter.localizedString(from: entryController.entries[indexPath.row].timestamp!, dateStyle: .short, timeStyle: .short)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let entry = entryController.entries[indexPath.row]
        entryController.deleteEntry(entry: entry)
        entryController.saveToPersistentStore()
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! EntryDetailViewController
        destination.entryController = entryController
        if segue.identifier == "ViewExistingEntryScene" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            destination.entry = entryController.entries[indexPath.row]
        }
    }

}
