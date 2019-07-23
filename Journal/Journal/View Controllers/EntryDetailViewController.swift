//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Kat Milton on 7/22/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var bodyTextView: UITextView!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var moodControl: UISegmentedControl!

    
    var entry: Entry? {
        didSet {
            self.updateViews()
        }
    }
    var entryController: EntryController?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        bodyTextView.delegate = self
        titleTextField.delegate = self
        updateViews()
        setupKeyboardDismissRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        updateViews()
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text,
            let bodyText = bodyTextView.text,
            !title.isEmpty else {
                let alert = UIAlertController(title: "No Title!", message: "Please add a title to your entry", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return }
        
        let mood = Mood.allMoods[moodControl.selectedSegmentIndex]
        
        
        if saveButton.title == "Edit" {
            titleTextField.isEnabled = true
            bodyTextView.isEditable = true
            
            bodyTextView.becomeFirstResponder()
            saveButton.title = "Save"
                
        } else {
            if let entry = entry {
                self.entryController?.updateEntry(entry: entry, title: title, bodyText: bodyText, mood: mood)
            } else {
                self.entryController?.createEntry(title: title, bodyText: bodyText, mood: mood)
        }
            navigationController?.popViewController(animated: true)
        }
        
        
    }

    func setAppearance() {
        view.backgroundColor = AppearanceHelper.whiteBackground
        titleTextField.backgroundColor = AppearanceHelper.whiteBackground
        bodyTextView.backgroundColor = AppearanceHelper.whiteBackground
    }
    
    func updateViews() {
        
        guard isViewLoaded else { return }
        
        setAppearance()
        if entry?.title == nil {
            title = "Create Entry"
            saveButton.tintColor = AppearanceHelper.highlightColor.withAlphaComponent(0.1)
        } else {
            title = nil
            saveButton.title = "Edit"
            if saveButton.title == "Edit" {
                titleTextField.isEnabled = false
                bodyTextView.isEditable = false
            }
        }
        
        let mood: Mood
        
        if let entryMood = entry?.mood {
            mood = Mood(rawValue: entryMood)!
        } else {
            mood = .😐
        }
        
        let moodIndex = Mood.allMoods.firstIndex(of: mood)!
        
        moodControl.selectedSegmentIndex = moodIndex
        
        
        titleTextField.text = entry?.title
        let placeHolder = "Enter your text"
        bodyTextView.text = entry?.bodyText ?? placeHolder
        if bodyTextView.text == placeHolder {
            bodyTextView.textColor = UIColor.lightGray
        } else {
            bodyTextView.textColor = UIColor.black
        }
        
    }
    
    func setupKeyboardDismissRecognizer(){
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(EntryDetailViewController.dismissKeyboard))
        
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    

}


extension EntryDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }  else if saveButton.title == "Edit" {
            UIView.animate(withDuration: 0.8, delay: 1.0, options: .curveEaseInOut, animations: {
                    self.saveButton.title = "Save"
                
        }, completion: nil)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your text"
            textView.textColor = UIColor.lightGray
        }
    }
    
}

extension EntryDetailViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "" {
            self.saveButton.tintColor = AppearanceHelper.highlightColor.withAlphaComponent(0.2)
            self.saveButton.isEnabled = false
        } else if saveButton.title == "Edit" {
            self.saveButton.title = "Save"
        } else {
            
            UIView.animate(withDuration: 0.8, delay: 1.0, options: .curveEaseIn, animations: {
                
                self.saveButton.tintColor = AppearanceHelper.highlightColor.withAlphaComponent(0.7)
                self.saveButton.isEnabled = true
            }, completion: nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if reason == .committed {
            if textField.text == "" {
                self.saveButton.tintColor = AppearanceHelper.highlightColor.withAlphaComponent(0.2)
                self.saveButton.isEnabled = false
            } else {
                
                UIView.animate(withDuration: 0.8, delay: 1.0, options: .curveEaseIn, animations: {
                    self.saveButton.tintColor = AppearanceHelper.highlightColor.withAlphaComponent(0.7)
                    self.saveButton.isEnabled = true
                }, completion: nil)
            }
        }
    }
    
    
}
