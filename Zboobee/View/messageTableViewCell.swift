//
//  messageTableViewCell.swift
//  Zboobee
//
//  Created by Laure Marchal on 20/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import UIKit

/// Class that describes the cell of the messages displayed on table
class messageTableViewCell: UITableViewCell {

    ///content of the message
    @IBOutlet weak var messageLabel: UILabel!
    ///user who send the message
    @IBOutlet weak var userLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
