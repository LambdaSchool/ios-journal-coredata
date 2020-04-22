//
//  CreateEntryViewController.swift
//  Journal
//
//  Created by Shawn James on 4/20/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {

    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moodSegmentedControl.selectedSegmentIndex = 1
        titleTextField.becomeFirstResponder()
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text,
                   !title.isEmpty else { return }
        
        let moodIndex = moodSegmentedControl.selectedSegmentIndex
        let mood = EntryMood.allCases[moodIndex]
        let entry = Entry(title: title, bodyText: bodyTextView.text, mood: mood.rawValue)
        
        entryController?.sendEntryToServer(entry: entry)
               do {
                   try CoreDataStack.shared.mainContext.save()
               } catch {
                   NSLog("Error saving managed object context: \(error)")
                   return
               }
               
               navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
}

