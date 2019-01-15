//
//  DetailViewController.swift
//  Journal Core Data
//
//  Created by Austin Cole on 1/14/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()

        // Do any additional setup after loading the view.
    }
    func updateViews() {
        guard viewIfLoaded != nil else {return}
        guard let entry = entry else {
            navigationItem.title = "Create Entry"
            return
        }
        navigationItem.title = entry.title
        titleTextField.text = entry.title
        bodyTextTextView.text = entry.bodyText
    
        guard let mood = entry.mood else {return}
        let correctMood = Moods.allCases.filter({ $0.rawValue == mood })
            moodSegmentedControl.selectedSegmentIndex = Moods.allCases.firstIndex(of: correctMood.first!)!
        
    }
    @IBAction func saveEntry(_ sender: Any) {
        guard let titleText = titleTextField.text, let bodyText = bodyTextTextView.text else {return}
        
        if let entry = entry {
            entryController?.updateEntry(entry: entry, title: titleText, bodyText: bodyText, mood: moodSegmentedControl.titleForSegment(at: moodSegmentedControl.selectedSegmentIndex)!)
            
        } else {
            entryController?.createEntry(title: titleText, bodyText: bodyText, mood: moodSegmentedControl.titleForSegment(at: moodSegmentedControl.selectedSegmentIndex)!)
        }
        print(entry)
        navigationController?.popViewController(animated: false)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
