//
//  loginController.swift
//  Zboobee
//
//  Created by Laure MARCHAL on 14/02/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import UIKit
import CoreData

class loginController: UIViewController, UITextFieldDelegate {
    
    var users: [User] = []
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailF: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        
        let email : String? = self.emailF.text
        let password : String? = self.passwordTF.text
        let errorPopup: UIAlertController = UIAlertController(title: "Registration is incomplete",
                                                              message: "",
                                                              preferredStyle: .alert)
        let cancelPopup = UIAlertAction(title: "Annuler",
                                        style: .default)
        errorPopup.addAction(cancelPopup)
        
        guard email != "" else{
            DialogBoxHelper.alert(view: self, withTitle: "No Email", andMessage: "Please enter a valid email or register")
            return
        }
        guard (password?.characters.count)! >= 6 else{
            DialogBoxHelper.alert(view: self, withTitle: "Incorrect Password", andMessage: "Password is at least 6-caracter long")
            return
        }
        
        guard UsersSet.canLogin(email: email!, password: password!) else{
            DialogBoxHelper.alert(view: self, withTitle: "Login Failed", andMessage: "Email or password is incorrect")
            return
        }
        self.performSegue(withIdentifier: "showHomeSegue", sender: self)
        
        
    }
    @IBAction func resetPasswordButton(_ sender: Any) {
    }
    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
