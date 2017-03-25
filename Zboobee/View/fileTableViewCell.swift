//
//  fileTableViewCell.swift
//  Zboobee
//
//  Created by Laure MARCHAL on 25/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import UIKit

/// Class that describes the cell of the files displayed on table
class fileTableViewCell: UITableViewCell {

    
    /// title of the file
    @IBOutlet weak var title: UILabel!
    
    /// url of the file
    @IBOutlet weak var urlToDoc: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
