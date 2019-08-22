//
//  ManageEntryVC:.swift
//  MyJournal
//
//  Created by Jeffrey Santana on 8/19/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

class ManageEntryVC: UIViewController {

	//MARK: - IBOutlets
	
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var storyTextView: UITextView!
	@IBOutlet weak var moodSegControl: UISegmentedControl!
	
	//MARK: - Properties
	
	var journalController: JournalController!
	var entry: Entry?
	private let textViewPlaceholder = "Tell us your story..."
	
	//MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupSegControl()
		setupTextView()
		setupKeyboardDismissRecognizer()
		updateViews()
	}
	
	//MARK: - IBActions
	
	@IBAction func saveBtnTapped(_ sender: Any) {
		guard let title = titleTextField.optionalText else { return }
		let story = storyTextView.text
		let emoji = MoodEmoji.allCases[moodSegControl.selectedSegmentIndex]
		if let entry = entry {
			journalController.updateEntry(entry: entry, title: title, story: story, mood: emoji)
		} else {
			journalController.createEntry(title: title, story: story, mood: emoji)
		}
		okAction(message: entry == nil ? "New journal entry created." : "Journal entry updated.")
	}
	
	//MARK: - Helpers
	
	private func setupSegControl() {
		let attributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
		moodSegControl.setTitleTextAttributes(attributes, for: .selected)
		moodSegControl.removeAllSegments()
		for index in 0..<MoodEmoji.allCases.count {
			moodSegControl.insertSegment(withTitle: MoodEmoji.allCases[index].rawValue, at: index, animated: true)
		}
		moodSegControl.selectedSegmentIndex = MoodEmoji.defaultIndex
	}
	
	private func updateViews() {
		guard let entry = entry else { return }
		titleTextField.text = entry.title
		storyTextView.text = entry.story
		if let mood = entry.mood, let emoji = MoodEmoji(rawValue: mood) {
			let emojiIndex = MoodEmoji.allCases.firstIndex(of: emoji) ?? MoodEmoji.defaultIndex
			moodSegControl.selectedSegmentIndex = emojiIndex
		}
	}
	
	private func okAction(message: String) {
		let alert = UIAlertController(title: "Saved!", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
			self.navigationController?.popViewController(animated: true)
		}))
		self.present(alert, animated: true)
	}
	
	private func setupKeyboardDismissRecognizer(){
		let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		self.view.addGestureRecognizer(tapRecognizer)
	}
	
	@objc private func dismissKeyboard() {
		view.endEditing(true)
	}
}

//MARK: - TextView Delegate

extension ManageEntryVC: UITextViewDelegate {
	private func setupTextView() {
		storyTextView.delegate = self
		storyTextView.text = textViewPlaceholder
		storyTextView.textColor = UIColor.lightGray
	}
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		if textView.textColor == UIColor.lightGray {
			textView.text = nil
			textView.textColor = UIColor.black
		}
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		if textView.text.isEmpty {
			textView.text = textViewPlaceholder
			textView.textColor = UIColor.lightGray
		}
	}
}

//MARK: - TextField Extension

extension UITextField {
	var optionalText: String? {
		let trimmedText = self.text?.trimmingCharacters(in: .whitespacesAndNewlines)
		return (trimmedText ?? "").isEmpty ? nil : trimmedText
	}
}
