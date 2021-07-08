//
//  EntryTableViewCell.swift
//  Journal Core Data
//
//  Created by Dillon McElhinney on 9/17/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    // MARK: - Utility Functions
    private func updateViews() {
        guard let entry = entry else { return }
        
        titleLabel.text = entry.title
        detailLabel.text = entry.bodyText
        timestampLabel.text = entry.formattedTimestamp
        
        switch entry.mood {
        case Moods.😐.rawValue: updateColors(.lightTan)
        case Moods.🙂.rawValue: updateColors(.lightGreen)
        case Moods.😔.rawValue: updateColors(.lightBlue)
        default: updateColors(.white)
        }
        backgroundColor = .darkerGray
    }
    
    private func updateColors(_ color: UIColor) {
        titleLabel.textColor = color
        detailLabel.textColor = color
        timestampLabel.textColor = color
    }
}
