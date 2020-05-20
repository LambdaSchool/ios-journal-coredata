//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Enzo Jimenez-Soto on 5/18/20.
//  Copyright © 2020 Enzo Jimenez-Soto. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func updateViews() {
        self.titleLabel.text = entry?.title
        self.timestampLabel.text = self.dateString(for: entry)
        self.descriptionLabel.text = entry?.bodyText
    }
    
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    func dateString(for entry: Entry?) -> String? {
        // execute with map if there is any date
        return entry?.timestamp.map { dateFormatter.string(from: $0) }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
