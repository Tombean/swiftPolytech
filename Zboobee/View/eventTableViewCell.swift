//
//  eventTableViewCell.swift
//  Zboobee
//
//  Created by polytech on 24/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import UIKit

class eventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var location: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
