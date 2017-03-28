//
//  showEventViewController.swift
//  Zboobee
//
//  Created by polytech on 26/03/2017.
//  Copyright © 2017 Tom SOMERVILLE ROBERTS. All rights reserved.
//

import Foundation
import UIKit

/// Class that controls the detailed event view
class showEventViewController: UIViewController{
    
    ///author
    @IBOutlet weak var author: UILabel!
    ///eventTitle
    @IBOutlet weak var eventTitle: UITextView!
    ///eventDesc
    @IBOutlet weak var eventDesc: UITextView!
    ///date
    @IBOutlet weak var date: UILabel!
    ///location
    @IBOutlet weak var location: UILabel!
    
    
    /// action to return to the old view
    ///
    /// - Parameter sender: no need to know
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
            self.eventDesc.text = aEvent.desc
            self.date.text = Helper.getFormattedDate(date:aEvent.date as! Date)
            self.location.text = aEvent.place
        }
    }
    
}
