//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Jeremy Taylor on 8/13/18.
//  Copyright © 2018 Bytes-Random L.L.C. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       updateViews()
    }
    
    @IBAction func save(_ sender: Any) {
        guard let titleText = titleTextField.text, let bodyText = bodyTextView.text else { return }
        if let entry = entry {
            entryController?.update(entry: entry, title: titleText, bodyText: bodyText)
        } else {
            entryController?.create(title: titleText, bodyText: bodyText)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
        title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        bodyTextView.text = entry?.bodyText
    }
}
