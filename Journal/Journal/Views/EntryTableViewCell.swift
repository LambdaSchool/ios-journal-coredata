//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Jordan Christensen on 9/17/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    var entry: Entry? {
        didSet {
            updateViews()
            setUI()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var journalEntryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        
        return formatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    func setUI() {
        backgroundColor = .background
        
        titleLabel.textColor = .textColor
        journalEntryLabel.textColor = .textColor
        dateLabel.textColor = .textColor
    }
    
    
    func updateViews() {
        titleLabel.text = entry?.title ?? ""
        journalEntryLabel.text = entry?.bodyText ?? ""
        dateLabel.text = dateFormatter.string(from: entry?.timeStamp ?? Date())
    }
}
