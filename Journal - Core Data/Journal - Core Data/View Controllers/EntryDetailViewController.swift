//
//  EntryDetailViewController.swift
//  Journal - Core Data
//
//  Created by Lisa Sampson on 8/20/18.
//  Copyright © 2018 Lisa Sampson. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        bodyTextView.text = entry?.bodyText
        
        guard let moodString = entry?.mood,
            let mood = EntryMood(rawValue: moodString) else { return }
        
        segmentedControl.selectedSegmentIndex = EntryMood.allMoods.index(of: mood)!
    }

    @IBAction func saveButtonWasTapped(_ sender: Any) {
        guard let title = titleTextField.text,
            let bodyText = bodyTextView.text else { return }
        
        let selectedMood = EntryMood.allMoods[segmentedControl.selectedSegmentIndex]
        
        if let entry = entry {
            entryController?.update(entry: entry, title: title, bodyText: bodyText, mood: selectedMood)
        } else {
            entryController?.create(title: title, bodyText: bodyText, mood: selectedMood)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
}
