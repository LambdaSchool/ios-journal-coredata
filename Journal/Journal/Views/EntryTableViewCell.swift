//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Jesse Ruiz on 10/14/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }

    // MARK: - Outlets
    @IBOutlet weak var entryTitle: UILabel!
    @IBOutlet weak var entryDescription: UILabel!
    @IBOutlet weak var entryTimeStamp: UILabel!
    
    func updateViews() {
        
        entryTitle?.text = entry?.title
        entryDescription.text = entry?.bodyText
        entryTimeStamp.text = String("\(entry?.timestamp)")
        
    }
}
