//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Yvette Zhukovsky on 11/5/18.
//  Copyright © 2018 Yvette Zhukovsky. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
 
    
    
    
        func updateViews(){
        guard let title = entry?.title, !title.isEmpty else {return}
        titleLabel.text = title
           // guard let body = entry?.bodytext else {return}
            bodyLabel.text = entry?.bodytext
            if let timestamp = entry?.timestamp {
           let df = DateFormatter()
                df.dateStyle = .short
                df.timeStyle = .short
                
                timeStamp.text = df.string(from: timestamp)
            }
            
        
        
    }
    

    
    
    
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var bodyLabel: UILabel!
    
    @IBOutlet weak var timeStamp: UILabel!
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }






    var entry: Entry?{
        didSet {
            updateViews()
            
        }
        
    }

}
