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
        
        print("bouton \"valider\" dans REGISTRATION cliqué")
        
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
        guard email != "" && isValidEmail(testStr: email!) else{
            errorMessage = errorMessage+"\nNo email address or format is not correct"
            errorPopup.message = errorMessage
            present(errorPopup, animated: true)
            return
        }
        guard password != "" && (password?.characters.count)! >= 6 else{
            errorMessage = errorMessage+"\nNo password or has less than 6 caracters"
            errorPopup.message = errorMessage
            present(errorPopup, animated: true)
            return
        }
        guard passwordConfirmation != "" && (passwordConfirmation?.characters.count)! >= 6 else{
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
        
        guard passwordConfirmation == password else{
            errorMessage = errorMessage+"\nPassword does not match password confirmation"
            errorPopup.message = errorMessage
            present(errorPopup, animated: true)
            return
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Application failed")
        }
        let context = appDelegate.persistentContainer.viewContext
        
        let newUser: User = User(context: context)
        newUser.firstname = firstName
        newUser.lastname = lastName
        newUser.mailUniv = email
        // ATTENTION CRYPTER LE PASSWORD PLUS TARD
        newUser.password = password
        if self.selectedRole == "Teacher"{
            
            let role: Teacher = Teacher(context: context)
            role.specialty = "info"
            newUser.role = role
        } else{
            let role: Student = Student(context: context)
            var a = self.selectedRole.characters.map { String($0) }
            role.year = Int16(a[2])!
            newUser.role = role
            print("ROLE... Ou promo... : "+String(role.year))

        }
        
        do {
            try context.save()

        } catch let error as NSError {
            // Raise error
        }
        
        
        return
        
    }
    
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var promoPV: UIPickerView!
    var selectedRole: String = ""
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
        self.selectedRole = pickerData[row]
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
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@etu.umontpellier.fr"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
}
