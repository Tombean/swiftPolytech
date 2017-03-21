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
    let segueHome = "showHomeSegue"
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailF: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        
        let email : String? = self.emailF.text
        let password : String? = self.passwordTF.text
        
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
        // initialize the user object that matches the user who logged in
        let user : User = UsersSet.findUser(email: email!)!
        if self.users.length > 0 {
            self.users[0] = user
        }else{
            self.users.append(user)
        }
        
        // passes the user to the wall view
        self.performSegue(withIdentifier: "showHomeSegue", sender: self)
    }
    
    @IBAction func resetPasswordButton(_ sender: Any) {
        DialogBoxHelper.alert(view: self, withTitle: "Password reset", andMessage: "Not available yet")
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
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == self.segueHome{
            print("in prepare function")
            let showWallViewController = segue.destination as! WallViewController
            showWallViewController.user = self.users[0]
        }
     }
    
    
}
