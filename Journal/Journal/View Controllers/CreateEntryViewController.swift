//
//  CreateEntryViewController.swift
//  Journal
//
//  Created by Juan M Mariscal on 4/22/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var journalTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: IBActions
    
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        
        guard let title = titleTextField.text,
            !title.isEmpty else { return }
        
        guard let journal = journalTextView.text,
            !journal.isEmpty else { return }
        Entry(title: title, bodyText: journal, context: CoreDataStack.shared.mainContext)
        
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving manage object context: \(error)")
        }
    }
}

