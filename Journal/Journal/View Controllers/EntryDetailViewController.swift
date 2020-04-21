//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Harmony Radley on 4/21/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

      // MARK: - Properties
    
    var entry: Entry?

    // MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var moodController: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
    }

    private func updateViews() {
        titleTextField.text = entry?.title
        titleTextField.isUserInteractionEnabled = isEditing

        entryTextView.text = entry?.bodyText
        entryTextView.isUserInteractionEnabled = isEditing

        let mood: MoodPriority
        
        if let moodPriority = entry?.mood {
            mood = MoodPriority(rawValue: moodPriority)!
        } else {
            mood = .😐
        }
        moodController.selectedSegmentIndex = MoodPriority.allCases.firstIndex(of: mood) ?? 1
        moodController.isUserInteractionEnabled = isEditing
    }

}
