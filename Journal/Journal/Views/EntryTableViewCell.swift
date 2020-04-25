//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Bree Jeune on 4/24/20.
//  Copyright © 2020 Young. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    private func updateViews() {

        if let entry = entry {
            titleLabel?.text = entry.title
            bodyTextLabel?.text = entry.bodyText
            dateLabel?.text = convertDateToString(for: entry.timestamp)
        }
    }

    private func convertDateToString(for date: Date?) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm"
        if let date = date {
            return df.string(from: date)
        } else {
            return ""
        }
    }

    // MARK: - Properties
    
    var entry: Entry? {
        didSet {

            updateViews()
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

}
