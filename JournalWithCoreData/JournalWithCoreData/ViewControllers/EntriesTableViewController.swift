//
//  EntriesTableViewController.swift
//  JournalWithCoreData
//
//  Created by Carolyn Lea on 8/13/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate
{
    // MARK: - Properties
    
    let entryController = EntryController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "mood", ascending: false), NSSortDescriptor(key: "timestamp", ascending: true)]
        
        let moc = CoreDataStack.shared.mainContext
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "mood", cacheName: nil)
        
        frc.delegate = self
        
        try! frc.performFetch()
        
        return frc
    }()
    
    // MARK: - Load
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType)
    {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else {return}
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return fetchedResultsController.sections?[section].name.capitalized
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryListCell", for: indexPath) as! EntryTableViewCell 

        let entry = fetchedResultsController.object(at: indexPath)
        cell.entry = entry 

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let entry = fetchedResultsController.object(at: indexPath)
            entryController.deleteEntry(entry: entry)
            tableView.reloadData()
        }
    }
    

    
    // MARK: - Navigation ShowEditEntry,ShowAddEntry

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ShowEditEntry"
        {
            let editView = segue.destination as! EntryDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow
            {
                editView.entryController = entryController
                editView.entry = fetchedResultsController.object(at: indexPath)
            }
        }
        
        if segue.identifier == "ShowAddEntry"
        {
            let addView = segue.destination as! EntryDetailViewController
            addView.entryController = entryController
        }
    }
    
    @IBAction func refresh(_ sender: Any)
    {
        entryController.fetchEntriesFromServer { _ in
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
            }
        }
    }
    

}
