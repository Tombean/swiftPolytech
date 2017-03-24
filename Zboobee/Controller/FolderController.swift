//
//  FolderController.swift
//  Zboobee
//
//  Created by Laure MARCHAL on 22/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import UIKit

class FolderController : UIViewController {
    
    var userloged : User?
    
    //sign out
    @IBAction func logoutButton(_ sender: Any) {
        UserSession.instance.user = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        self.userloged = UserSession.instance.user
        guard let user = self.userloged else{
            fatalError("No user selected!!!")
        }
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
}
