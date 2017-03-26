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
    ///newPassword2TF
    @IBOutlet weak var newPassword2TF: UITextField!
    ///newPasswordTF
    @IBOutlet weak var newPasswordTF: UITextField!
    ///oldPasswordTF
    @IBOutlet weak var oldPasswordTF: UITextField!
    ///titleLabel
    @IBOutlet weak var titleLabel: UILabel!
    ///studentAccountButton
    @IBOutlet weak var studentAccountButton: UIButton!
    ///teacherAccountButton
    @IBOutlet weak var teacherAccountButton: UIButton!
    ///saveButtonRef
    @IBOutlet weak var saveButtonRef: UIButton!
    
    /// action to save the new password of a user
    ///
    /// - Parameter sender: no need to know
    @IBAction func saveButton(_ sender: Any) {
        //get the text of the TF
        let oldPassword : String? = self.oldPasswordTF.text
        let newPassword : String? = self.newPasswordTF.text
        let newPasswordConfirmation : String? = self.newPassword2TF.text
        
        //Verify that the password makes more than 6 characters
        guard oldPassword != "" && (UsersSet.canLogin(email: (userloged?.mailUniv)!, password: oldPassword!)) else{
            DialogBoxHelper.alert(view: self, withTitle: "Change is incomplete", andMessage: "No password, password must be the one you use to log in")
            return
        }
        //Verify that the confirmedpassword makes more than 6 characters
        guard newPassword != "" && (newPassword?.characters.count)! >= 6 else{
            DialogBoxHelper.alert(view: self, withTitle: "Change is incomplete", andMessage: "No new password, password must contain at least 6 characters")
            return
        }
        //Verify that the password corresponds to the confirmedpassword-
        guard newPassword == newPasswordConfirmation else{
            DialogBoxHelper.alert(view: self, withTitle: "Change is incomplete", andMessage: "New Password does not match New password confirmation")
            return
        }
        //Update the password of the user
        let ok = User.updatePassword(user: userloged!,newpassword:newPassword!)
        //inform the user that it works or not
        guard (ok == nil) else {
            DialogBoxHelper.alert(view: self, withTitle: "Update Password Failed", andMessage: "The password didn't change")
            return
        }
        DialogBoxHelper.alert(view: self, withTitle: "Update Password Succeed", andMessage: "Your password has been changed")
        self.oldPasswordTF.text = ""
        self.newPasswordTF.text = ""
        self.newPassword2TF.text = ""
    }
    
    
    /// action to sign out : shows 2 possibilities : really sign out on "OK" and cancel this action on "Cancel"
    ///
    /// - Parameter sender: no need to know
    @IBAction func logoutButton(_ sender: Any) {
        let dismissAction = UIAlertAction(title: "Ok", style: .default, handler: self.dismissSelf)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        DialogBoxHelper.alert(view: self, withTitle: "Confirmation", andMessage: "Are you sure you want to log out ?", actions: [dismissAction,cancelAction])
    }
    /// dismiss this screen and go back to the old one
    ///
    /// - Parameter _: action that must be done
    private func dismissSelf(_ :UIAlertAction) -> Void{
        UserSession.instance.user = nil
        self.dismiss(animated: true, completion: nil)
    }
    ///Lunch the view
    override func viewDidLoad() {
        //get the user who is logged
        self.userloged = UserSession.instance.user
        //Verify that the user is get fine
        guard self.userloged != nil else{
            fatalError("No user selected!!!")
        }
        //Verify that the user is an Office or a manager to swow the account settings
        if (self.userloged is Office){
            self.teacherAccountButton.isHidden = false
            self.studentAccountButton.isHidden = false
            self.saveButtonRef.isHidden = true
            self.oldPasswordTF.isHidden = true
            self.newPasswordTF.isHidden = true
            self.newPassword2TF.isHidden = true
        }else{
            if (self.userloged is Teacher ){
                if ((Teacher.isManager(email:(self.userloged?.mailUniv)!))){
                    self.teacherAccountButton.isHidden = false
                    self.studentAccountButton.isHidden = false
                    self.saveButtonRef.isHidden = true
                    self.oldPasswordTF.isHidden = true
                    self.newPasswordTF.isHidden = true
                    self.newPassword2TF.isHidden = true
                }else{ //If he's not he can change his password
                    self.teacherAccountButton.isHidden = true
                    self.studentAccountButton.isHidden = true
                    self.saveButtonRef.isHidden = false
                    self.oldPasswordTF.isHidden = false
                    self.newPasswordTF.isHidden = false
                    self.newPassword2TF.isHidden = false
                }
            }else{
                self.teacherAccountButton.isHidden = true
                self.studentAccountButton.isHidden = true
                self.saveButtonRef.isHidden = false
                self.oldPasswordTF.isHidden = false
                self.newPasswordTF.isHidden = false
                self.newPassword2TF.isHidden = false
            }
        }
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    
}
