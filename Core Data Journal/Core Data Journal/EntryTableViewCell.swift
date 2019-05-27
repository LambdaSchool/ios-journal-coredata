//
//  EntryTableViewCell.swift
//  Core Data Journal
//
//  Created by Michael Redig on 5/27/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

	@IBOutlet var myContentView: UIView!
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var detailLabel: UILabel!
	@IBOutlet var timestampLabel: UILabel!
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		commonInit()
	}

	private func commonInit() {
		let nib = UINib(nibName: "EntryTableViewCell", bundle: nil)
		nib.instantiate(withOwner: self, options: nil)
//		myContentView.frame = self.bounds
		myContentView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(myContentView)
		myContentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		myContentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		myContentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		myContentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
	}
}
