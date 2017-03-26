//
//  showEventViewController.swift
//  Zboobee
//
//  Created by polytech on 26/03/2017.
//  Copyright © 2017 Tom SOMERVILLE ROBERTS. All rights reserved.
//

import Foundation
import UIKit

/// Class that controls the detailed message view
class showEventViewController: UIViewController{
    
 
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var eventTitle: UITextView!
    @IBOutlet weak var eventDesc: UITextView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //variable message we want to detail
    var event : Event? = nil
    
    ///Launch the view
    override func viewDidLoad() {
        if let aEvent = self.event{
            self.author.text = ("\((aEvent.isCreated?.firstname)!) \((aEvent.isCreated?.lastname)!)")
            self.eventTitle.text = aEvent.title
            self.eventDesc.text = aEvent.description
            self.date.text = Helper.getFormattedDate(date:aEvent.date as! Date)
            self.location.text = aEvent.place
        }
    }
    
}
