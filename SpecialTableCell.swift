//
//  SpecialTableCell.swift
//  emojigame
//
//  Created by Adam Sigel on 7/19/16.
//  Copyright © 2016 Adam Sigel. All rights reserved.
//

import Foundation
import UIKit

class SpecialCell: UITableViewCell {
    
    @IBOutlet var plot: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
