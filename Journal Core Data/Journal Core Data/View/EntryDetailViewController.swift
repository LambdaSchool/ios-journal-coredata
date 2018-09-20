//
//  EntryDetailViewController.swift
//  Journal Core Data
//
//  Created by Dillon McElhinney on 9/17/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import UIKit
import CoreData

class EntryDetailViewController: UIViewController {

    // MARK: - Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var objectID: NSManagedObjectID? {
        didSet{
            if let objectID = objectID {
                childContext.performAndWait {
                    entry = childContext.object(with: objectID) as? Entry
                }
            }
        }
    }
    var entryController: EntryController?
    lazy var childContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = CoreDataStack.shared.mainContext
        return context
    }()
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
    }
    
    // MARK: - UI Methods
    @IBAction func saveEntry(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty,
            let bodyText = bodyTextView.text, !bodyText.isEmpty,
        let mood = moodSegmentedControl.titleForSegment(at: moodSegmentedControl.selectedSegmentIndex), let entry = entry else { return }
//
//        if let entry = entry {
//            entryController?.update(entry: entry, title: title, bodyText: bodyText, mood: mood)
//        } else {
//            entryController?.createEntry(title: title, bodyText: bodyText, mood: mood)
//        }
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        
        childContext.performAndWait {
            do {
                try childContext.save()
            } catch {
                NSLog("Error saving child context: \(error)")
            }
        }

        entryController?.update(entry: entry)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Utility Methods
    private func updateViews() {
        guard isViewLoaded else { return }
        guard let entry = entry else {
            moodSegmentedControl.selectedSegmentIndex = 1
            title = "Add Entry"
            self.entry = Entry(context: childContext)
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
    
    private func setupView() {
        view.backgroundColor = .darkerGray
        titleTextField.textColor = .white
        titleTextField.backgroundColor = .darkerGray
        bodyTextView.textColor = .white
        bodyTextView.backgroundColor = .darkerGray
        titleTextField.attributedPlaceholder = NSAttributedString(string: "Enter a title", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        setupSegmentedControl()
        updateViews()
    }
}
