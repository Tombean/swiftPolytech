//
//  SettingsController.swift
//  Zboobee
//
//  Created by Laure MARCHAL on 22/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import UIKit

class SettingsController : UIViewController{
    
    var userloged : User?
    
    @IBAction func desactivateButton(_ sender: Any) {
    }
    @IBAction func activateButton(_ sender: Any) {
    }
    
    //sign out
    @IBAction func logoutButton(_ sender: Any) {
        let dismissAction = UIAlertAction(title: "Ok", style: .default, handler: self.dismissSelf)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        DialogBoxHelper.alert(view: self, withTitle: "Confirmation", andMessage: "Are you sure you want to log out ?", actions: [dismissAction,cancelAction])
    }
    
    private func dismissSelf(_ :UIAlertAction) -> Void{
        UserSession.instance.user = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        self.userloged = UserSession.instance.user
        guard self.userloged != nil else{
            fatalError("No user selected!!!")
        }
        super.viewDidLoad()
        guard ((self.userloged is Teacher) || (self.userloged is Office)) else{
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            DialogBoxHelper.alert(view: self, withTitle: "Unauthorized feature", andMessage: "User settings are only for techers and office", action: cancelAction )
            return
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
}
