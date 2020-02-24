//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Chris Gonzales on 2/24/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    

    @IBOutlet var entryTitleLabel: UITextField!
    
    @IBOutlet weak var entryDescriptionText: UILabel!
    
    @IBOutlet weak var timeStamp: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
