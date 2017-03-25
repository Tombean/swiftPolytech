//
//  SettingsController.swift
//  Zboobee
//
//  Created by Laure MARCHAL on 25/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import UIKit


class SettingsController : UIViewController{

    //Variable user get from the login
    var userloged : User?
    
    @IBOutlet weak var newPassword2TF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var oldPasswordTF: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var studentAccountButton: UIButton!
    
    @IBAction func saveButton(_ sender: Any) {
    }
    @IBOutlet weak var teacherAccountButton: UIButton!
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
        if(self.userloged is Office){
            self.teacherAccountButton.isHidden = false
            self.studentAccountButton.isHidden = false
            self.oldPasswordTF.isHidden = true
            self.newPasswordTF.isHidden = true
            self.newPassword2TF.isHidden = true
        }else{
            self.teacherAccountButton.isHidden = true
            self.studentAccountButton.isHidden = true
            self.oldPasswordTF.isHidden = false
            self.newPasswordTF.isHidden = false
            self.newPassword2TF.isHidden = false
        }
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    
}
