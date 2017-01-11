//
//  CustomCell.swift
//  Buurt
//
//  Created by Martijn de Jong on 11-01-17.
//  Copyright © 2017 Martijn de Jong. All rights reserved.
//

import UIKit

class MentionCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var iconHolder: UIImageView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var messageField: UITextView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
