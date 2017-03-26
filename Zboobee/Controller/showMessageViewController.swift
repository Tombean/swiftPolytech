//
//  showMessageViewController.swift
//  Zboobee
//
//  Created by polytech on 26/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import UIKit

class showMessageViewController: UIViewController{
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var titleView: UITextView!
    @IBOutlet weak var messageView: UITextView!
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var message : Message? = nil
    
    override func viewDidLoad() {
        if let aMessage = self.message{
            self.author.text = ("\((aMessage.isPosted?.firstname)!) \((aMessage.isPosted?.lastname)!)")
            self.titleView.text = aMessage.title
            self.messageView.text = aMessage.content
        }
    }
    
}
