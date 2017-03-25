//
//  studentTableViewCell.swift
//  Zboobee
//
//  Created by Laure MARCHAL on 25/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import UIKit

class studentTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var firstname: UILabel!
    @IBOutlet weak var lastname: UILabel!
    @IBOutlet weak var promotion: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
