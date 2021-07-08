//
//  EntryDetailViewController.swift
//  Journal Core Data
//
//  Created by Dillon McElhinney on 9/17/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    // MARK: - Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSegmentedControl()
        updateViews()

    }
    
    // MARK: - UI Methods
    @IBAction func saveEntry(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty,
            let bodyText = bodyTextView.text, !bodyText.isEmpty,
        let mood = moodSegmentedControl.titleForSegment(at: moodSegmentedControl.selectedSegmentIndex) else { return }
        
        if let entry = entry {
            entryController?.update(entry: entry, title: title, bodyText: bodyText, mood: mood)
        } else {
            entryController?.createEntry(title: title, bodyText: bodyText, mood: mood)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Utility Methods
    private func updateViews() {
        guard isViewLoaded else { return }
        view.backgroundColor = .darkerGray
        titleTextField.textColor = .white
        titleTextField.backgroundColor = .darkerGray
        bodyTextView.textColor = .white
        bodyTextView.backgroundColor = .darkerGray
        guard let entry = entry else {
            moodSegmentedControl.selectedSegmentIndex = 1
            title = "Add Entry"
            return
        }
        
        title = entry.title
        titleTextField.text = entry.title
        bodyTextView.text = entry.bodyText
        

        
        
        let mood: Moods = Moods(rawValue: entry.mood ?? "😐") ?? .😐
        
        moodSegmentedControl.selectedSegmentIndex = Moods.allCases.index(of: mood) ?? 1
    }
    
    private func setupSegmentedControl() {
        moodSegmentedControl.removeAllSegments()
        for (index, mood) in Moods.allCases.enumerated() {
            moodSegmentedControl.insertSegment(withTitle: mood.rawValue, at: index, animated: false)
        }
    }
}
