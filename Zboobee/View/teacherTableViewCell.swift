//
//  teacherTableViewCell.swift
//  Zboobee
//
//  Created by Laure MARCHAL on 25/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import UIKit

class teacherTableViewCell: UITableViewCell {
    

    
    @IBOutlet weak var lastname: UILabel!
    @IBOutlet weak var firstname: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
