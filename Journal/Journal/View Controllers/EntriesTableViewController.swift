//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Harmony Radley on 4/20/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {

    // Computed property that fetches all entry entites from Core Data 
    var entrys: [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let context = CoreDataStack.shared.mainContext
        do {
            return try context.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching entrys: \(error)")
            return []
        }
    }
    
    override func viewDidLoad() {
        self.tableView.rowHeight = 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // This allows the table view to be notified of changes to the data model
        tableView.reloadData()
    }

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entrys.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EntryTableViewCell.reuseIdentifier, for: indexPath) as?
            EntryTableViewCell else {
                fatalError("Can't dequeue cell of type \(EntryTableViewCell.reuseIdentifier)")
        }
        // Configure the cell...
        cell.entry = entrys[indexPath.row]
        return cell
    }
    

   
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
   

}
