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
        
        
        let context =  CoreDataManager.context
        let requestUsers: NSFetchRequest<User> = User.fetchRequest()
        do{
            try self.users = context.fetch(requestUsers)
        }catch let error as NSError{
            DialogBoxHelper.alert(view: self, error: error)
        }
        let indexOfUser = findUserInContext(withName: email!)
        guard userCanLogin(email: email!, password: password!, indexOfUser: indexOfUser) else{
            print("login failed")
            return
        }
        print("login OK")
        // SEGUE A FAIRE
       
        
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
    
    func findUserInContext(withName email : String)->Int{
        var indexOfUser: Int = 0
        while indexOfUser < self.users.count-1 || self.users[indexOfUser].mailUniv != email{
            indexOfUser = indexOfUser+1
        }
        return indexOfUser
    }
    func userCanLogin( email : String, password : String, indexOfUser : Int)->Bool{
        guard indexOfUser >= self.users.count-1 else{
            DialogBoxHelper.alert(view: self, withTitle: "User not found", andMessage: "Please enter a valid email or register")
            return false
        }
        guard email == self.users[indexOfUser].mailUniv else{
            DialogBoxHelper.alert(view: self, withTitle: "Invalid email", andMessage: "Please enter a valid email or register")
            return false
        }
        return true
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
