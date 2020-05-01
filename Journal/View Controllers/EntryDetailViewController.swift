//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Chad Parker on 4/25/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import UIKit
import CoreData

class EntryDetailViewController: UIViewController {
    
    var entry: Entry?
    var entryController: EntryController?
    
    private var wasEdited = false
    
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var moodSegmentControl: UISegmentedControl!
    @IBOutlet private weak var bodyTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setRightBarButton(editButtonItem, animated: false)
        updateViews()
    }
    
    private func updateViews() {
        guard let entry = entry else { fatalError() }
        
        let moodString = entry.mood ?? ""
        let mood = Mood(rawValue: moodString) ?? Mood.😐
        let moodIndex = Mood.allCases.firstIndex(of: mood) ?? 1
        
        titleTextField.text = entry.title
        moodSegmentControl.selectedSegmentIndex = moodIndex
        bodyTextView.text = entry.bodyText
        
        [titleTextField, moodSegmentControl, bodyTextView].forEach {
            $0?.isUserInteractionEnabled = isEditing
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            wasEdited = true
        }
        [titleTextField, moodSegmentControl, bodyTextView].forEach {
            $0?.isUserInteractionEnabled = editing
        }
        navigationItem.hidesBackButton = editing
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if wasEdited {
            guard
                let entry = entry,
                let id = entry.identifier,
                let title = titleTextField.text,
                let body = bodyTextView.text else { return }
            
            let mood = Mood.allCases[moodSegmentControl.selectedSegmentIndex]
            
            let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", id)
            
            do {
                let matchingEntries = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
                let existingEntry = matchingEntries[0]
                existingEntry.title = title
                existingEntry.mood = mood.rawValue
                existingEntry.bodyText = body
                try CoreDataStack.shared.mainContext.save()
                entryController?.sendEntryToServer(existingEntry)
            } catch {
                NSLog("Error saving: \(error)")
            }
        }
    }
}
