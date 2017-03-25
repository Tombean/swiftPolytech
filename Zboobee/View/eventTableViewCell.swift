//
//  eventTableViewCell.swift
//  Zboobee
//
//  Created by polytech on 24/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import UIKit

/// Class that describes the cell of the events displayed on table
class eventTableViewCell: UITableViewCell {
    
    ///title of the event
    @IBOutlet weak var title: UILabel!
    ///date of the event
    @IBOutlet weak var date: UILabel!
    ///duration of the event
    @IBOutlet weak var duration: UILabel!
    ///user who posted the event
    @IBOutlet weak var user: UILabel!
    ///location of the event
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
