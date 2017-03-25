//
//  teacherTableViewCell.swift
//  Zboobee
//
//  Created by Laure MARCHAL on 25/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import UIKit

/// Class that describes the cell of the teachers displayed on table
class teacherTableViewCell: UITableViewCell {
    
    /// lastname of the teacher
    @IBOutlet weak var lastname: UILabel!
    /// firstname of the teacher
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
