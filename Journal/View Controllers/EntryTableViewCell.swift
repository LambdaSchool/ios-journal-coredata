//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Andrew Ruiz on 10/14/19.
//  Copyright © 2019 Andrew Ruiz. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyText: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateViews() {
        
        guard let unwrappedEntry = entry else { return }
        
        titleLabel.text = unwrappedEntry.title
        bodyText.text = unwrappedEntry.bodyText
        
        let dateFormatter = DateFormatter()
        timeStamp.text = dateFormatter.string(from: Date())

    }
}
