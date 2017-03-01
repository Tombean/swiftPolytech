//
//  RegistrationController.swift
//  Zboobee
//
//  Created by Tom SOMERVILLE-ROBERTS on 27/02/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import UIKit
import CoreData

class RegistrationController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmpasswordTF: UITextField!
   
    @IBAction func validateButton(_ sender: Any) {
        
        print("bouton valider cliqué")
        
        let firstName : String? = self.firstNameTF.text
        let lastName : String? = self.lastNameTF.text
        let email : String? = self.emailTF.text
        let password : String? = self.passwordTF.text
        let passwordConfirmation : String? = self.confirmpasswordTF.text
        var errorMessage: String = ""
        let errorPopup: UIAlertController = UIAlertController(title: "Registration is incomplete",
                                                              message: "",
                                                              preferredStyle: .alert)
        let cancelPopup = UIAlertAction(title: "Annuler",
                                        style: .default)
        errorPopup.addAction(cancelPopup)
        
        guard firstName != "" else{
            errorMessage = errorMessage+"\nNo first name \n"
            errorPopup.message = errorMessage
            present(errorPopup, animated: true)
            return
        }
        guard lastName != "" else{
            errorMessage = errorMessage+"\nNo last name"
            errorPopup.message = errorMessage
            present(errorPopup, animated: true)
            return
        }
        guard email != "" else{
            errorMessage = errorMessage+"\nNo email address"
            errorPopup.message = errorMessage
            present(errorPopup, animated: true)
            return
        }
        guard password != "" else{
            errorMessage = errorMessage+"\nNo password"
            errorPopup.message = errorMessage
            present(errorPopup, animated: true)
            return
        }
        guard passwordConfirmation != "" else{
            errorMessage = errorMessage+"\nNo password confirmation"
            errorPopup.message = errorMessage
            present(errorPopup, animated: true)
            return
        }
        guard passwordConfirmation != "" else{
            errorMessage = errorMessage+"\nNo password confirmation"
            errorPopup.message = errorMessage
            present(errorPopup, animated: true)
            return
        }
        guard passwordConfirmation != password else{
            errorMessage = errorMessage+"\nPassword does not match password confirmation"
            errorPopup.message = errorMessage
            present(errorPopup, animated: true)
            return
        }
        
        return
        
    }
    /*
    @IBAction func validateButton(_ sender: Any) {
        
     

        
    } */
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var promoPV: UIPickerView!
    
    let pickerData = ["IG3","IG4","IG5","Teacher"]
    
        override func viewDidLoad() {
        super.viewDidLoad()
        self.promoPV.dataSource = self
        self.promoPV.delegate = self
        self.firstNameTF.delegate = self
        self.lastNameTF.delegate = self
        self.emailTF.delegate = self
        self.passwordTF.delegate = self
        self.confirmpasswordTF.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected objec
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /*
    func saveButton() -> Bool {
        let firstName : String? = self.firstNameTF.text
        let lastName : String? = self.lastNameTF.text
        let email : String? = self.emailTF.text
        let password : String? = self.passwordTF.text
        let passwordConfirmation : String? = self.confirmpasswordTF.text
        
        guard firstName != nil else{
            print("No first name")
            return false
        }
        guard lastName != nil else{
            print("No last name")
            return false
        }
        guard email != nil else{
            print("No email address")
            return false
        }
        guard password != nil else{
            print("No password")
            return false
        }
        guard passwordConfirmation != nil else{
            print("No password confirmation")
            return false
        }
        guard passwordConfirmation != password else{
            print("Password does not match password confirmation")
            return false
        }
        return true
    }
 */
}
