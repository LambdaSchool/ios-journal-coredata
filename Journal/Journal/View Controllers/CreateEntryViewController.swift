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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
               
        Entry(title: title, bodyText: bodyTextView.text, mood: mood.rawValue)
               do {
                   try CoreDataStack.shared.mainContext.save()
               } catch {
                   NSLog("Error saving managed object context: \(error)")
                   return
               }
               
               navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
}

