//
//  ViewController.swift
//  Journal
//
//  Created by Mark Gerrior on 3/23/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    // MARK: - Properities
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateViews()
    }

    private func updateViews() {
        // FIXME: ? Make sure the view is loaded.
        
        if let entry = entry {
            title = entry.title
            titleTextField?.text = entry.title
            entryTextView?.text = entry.bodyText
            
            moodSegmentedControl?.selectedSegmentIndex = Mood.index(entry.mood!)
            
        } else {
            title = "Create Entry"
            moodSegmentedControl?.selectedSegmentIndex = 1
        }
    }
    
    // MARK: - Actions
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let ec = entryController,
            let title = titleTextField.text,
            !title.isEmpty,
            let bodyText = entryTextView?.text else { return }

        let moodIndex = moodSegmentedControl.selectedSegmentIndex
        let mood = Mood.allCases[moodIndex]

        if entry == nil {
            ec.create(identifier: UUID().uuidString,
                      title: title,
                      bodyText: bodyText,
                      mood: mood)
        } else {
            ec.update(entry: entry!, title: title, bodyText: bodyText, mood: mood)
        }
        navigationController?.popViewController(animated: true)
//        navigationController?.dismiss(animated: true, completion: nil)
    }

}

