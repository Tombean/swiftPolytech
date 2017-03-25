//
//  loginController.swift
//  Zboobee
//
//  Created by Laure MARCHAL on 14/02/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.    
//

import UIKit
import CoreData

/// Class that controls the login view
class loginController: UIViewController, UITextFieldDelegate {
    
    ///variable to keep the user who wants to log in
    var userloged: User? = nil
    ///the segue to go to the wall of messages and save the userloged
    let segueHome = "showHomeSegue"
    ///password TF
    @IBOutlet weak var passwordTF: UITextField!
    ///email TF
    @IBOutlet weak var emailF: UITextField!
    
    /// action of the login Button that verify the TF and ask if the log in is possible
    ///
    /// - Parameter sender: no need to know
    @IBAction func loginButton(_ sender: Any) {
        
        //get the text of the TF
        let email : String? = self.emailF.text
        let password : String? = self.passwordTF.text
        
        //Verify that email is not empty
        guard email != "" else{
            DialogBoxHelper.alert(view: self, withTitle: "No Email", andMessage: "Please enter a valid email or register")
            return
        }
        //Verify that password has at least 6 characters
        guard (password?.characters.count)! >= 6 else{
            DialogBoxHelper.alert(view: self, withTitle: "Incorrect Password", andMessage: "Password is at least 6-caracter long")
            return
        }
        
        //Verify that the user exists and the password corresponds to the email
        guard UsersSet.canLogin(email: email!, password: password!) else{
            DialogBoxHelper.alert(view: self, withTitle: "Login Failed", andMessage: "Email or password is incorrect")
            return
        }
        // initialize the user object that matches the user who wants to log in
        let user : User? = UsersSet.findUser(email: email!)!
        //Verify that the user is set
        guard user != nil else{
            DialogBoxHelper.alert(view: self, withTitle: "Login Failed", andMessage: "This Email is not registered")
            return
        }
        //verify if the user is a student to verify if his account is valide
        if (user is Student){
            guard UsersSet.isValideStud(email: email!) else{
                DialogBoxHelper.alert(view: self, withTitle: "Login Failed", andMessage: "Your account is not valid")
                return
            }
        }else{//verify if the user is a teacher to verify if his account is valide
            if (user is Teacher){
                guard UsersSet.isValideTeach(email: email!) else{
                    DialogBoxHelper.alert(view: self, withTitle: "Login Failed", andMessage: "Your account is not valid")
                    return
                }
            }
        }
        self.userloged = user
        
        // go to the wall view
        self.performSegue(withIdentifier: "showHomeSegue", sender: self)
    }
    
    /// reset the password if the user forget
    ///
    /// - Parameter sender: no need to know
    @IBAction func resetPasswordButton(_ sender: Any) {
        DialogBoxHelper.alert(view: self, withTitle: "Password reset", andMessage: "Not available yet")
    }
    
    ///Button to go to the registration view
    @IBOutlet weak var registerButton: UIButton!
    
    
    /// lunch the view
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        ///set the user who is logging
        if segue.identifier == self.segueHome{
            UserSession.instance.user = self.userloged
            //let showWallViewController = segue.destination.childViewControllers[0] as! WallViewController
        }
     }
    
    
}
