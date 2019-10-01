//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by John Kouris on 9/30/19.
//  Copyright © 2019 John Kouris. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var bodyTextView: UITextView!
    
    var entry: Entry?
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        navigationItem.largeTitleDisplayMode = .never
        title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        bodyTextView.text = entry?.bodyText
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let title = titleTextField.text,
            let bodyText = bodyTextView.text else { return }
        guard !title.isEmpty, title != " " else {
            let ac = UIAlertController(title: "Oops!", message: "Please enter a title for your journal entry before saving!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
            return
        }
        
        if let entry = entry {
            entryController?.updateEntry(entry: entry, with: title, bodyText: bodyText)
        } else {
            entryController?.createEntry(with: title, bodyText: bodyText)
        }
        navigationController?.popViewController(animated: true)
    }
    

}
