//
//  showMessageViewController.swift
//  Zboobee
//
//  Created by polytech on 26/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import UIKit

/// Class that controls the detailed message view
class showMessageViewController: UIViewController{
    
    ///author
    @IBOutlet weak var author: UILabel!
    ///titleView
    @IBOutlet weak var titleView: UITextView!
    ///messageView
    @IBOutlet weak var messageView: UITextView!
    
    
    /// action back button to return to the wall view
    ///
    /// - Parameter sender: no need to know
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //variable message we want to detail
    var message : Message? = nil
    
    ///Launch the view
    override func viewDidLoad() {
        if let aMessage = self.message{
            self.author.text = ("\((aMessage.isPosted?.firstname)!) \((aMessage.isPosted?.lastname)!)")
            self.titleView.text = aMessage.title
            self.messageView.text = aMessage.content
        }
    }
    
}
