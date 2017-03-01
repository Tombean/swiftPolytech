//
//  loginController.swift
//  Zboobee
//
//  Created by Laure MARCHAL on 14/02/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import UIKit

class loginController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailF: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        
        let email : String? = self.emailF.text
        let password : String? = self.passwordTF.text
        var errorMessage: String = ""
        let errorPopup: UIAlertController = UIAlertController(title: "Registration is incomplete",
                                                              message: "",
                                                              preferredStyle: .alert)
        let cancelPopup = UIAlertAction(title: "Annuler",
                                        style: .default)
        errorPopup.addAction(cancelPopup)
        
        guard email != "" else{
            errorMessage = errorMessage+"\nNo email address or format is not correct"
            errorPopup.message = errorMessage
            present(errorPopup, animated: true)
            return
        }
        guard password != "" else{
            errorMessage = errorMessage+"\nNo password or has less than 6 caracters"
            errorPopup.message = errorMessage
            present(errorPopup, animated: true)
            return
        }
       

        
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
