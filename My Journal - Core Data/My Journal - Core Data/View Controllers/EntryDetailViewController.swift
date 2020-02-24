//
//  ViewController.swift
//  My Journal - Core Data
//
//  Created by Nick Nguyen on 2/24/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController
{

    
    
    // MARK: - Properties
    
    var entry: Entry?
    var entryController: EntryController?
    
    
    private var entryTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter a title"
        textField.becomeFirstResponder()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .bezel
        return textField
    }()
    
    private var entryTextView: UITextView = {
        let textView = UITextView()
        textView.text = ""
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .green
        textView.autocapitalizationType = .words
        return textView
    }()
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        setUpSubviews()
        layoutSubviews()
    }


    
    // MARK: - Methods
    
    private func configureNavBar() {
        title = "Create Entry"
       
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
    }
    
    @objc private func saveTapped() {
        print("Hello")
    }
    
    
    private func setUpSubviews() {
        view.addSubview(entryTextField)
        view.addSubview(entryTextView)
    }
    
    
    private func layoutSubviews() {
        NSLayoutConstraint.activate([
            entryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            entryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            entryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 16),
            entryTextField.heightAnchor.constraint(equalToConstant: 50),
        
            entryTextView.leadingAnchor.constraint(equalTo: entryTextField.leadingAnchor),
            entryTextView.trailingAnchor.constraint(equalTo: entryTextField.trailingAnchor),
            entryTextView.topAnchor.constraint(equalTo: entryTextField.bottomAnchor, constant: 32),
            entryTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32)
            
        ])
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

