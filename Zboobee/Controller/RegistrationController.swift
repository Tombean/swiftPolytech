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
    var indexOfRole : Int = 0
    
    @IBAction func validateButton(_ sender: Any) {
    
        let firstName : String? = self.firstNameTF.text
        let lastName : String? = self.lastNameTF.text
        let email : String? = self.emailTF.text
        let password : String? = self.passwordTF.text
        let passwordConfirmation : String? = self.confirmpasswordTF.text

        guard firstName != "" else{
            DialogBoxHelper.alert(view: self, withTitle: "Registration is incomplete", andMessage: "No first name")
            return
        }
        guard lastName != "" else{
            DialogBoxHelper.alert(view: self, withTitle: "Registration is incomplete", andMessage: "No last name")
            return
        }
        guard email != "" && isValidEmail(testStr: email!) else{
            DialogBoxHelper.alert(view: self, withTitle: "Registration is incomplete", andMessage: "No email or invalid format : please use your @etu.umontpellier.fr email address")
            return
        }
        guard password != "" && (password?.characters.count)! >= 6 else{
            DialogBoxHelper.alert(view: self, withTitle: "Registration is incomplete", andMessage: "No password, password must contain at least 6 characters")
            return
        }
        guard passwordConfirmation != "" && (passwordConfirmation?.characters.count)! >= 6 else{
           DialogBoxHelper.alert(view: self, withTitle: "Registration is incomplete", andMessage: "No password confirmation, password confirmation must contain at least 6 characters")
            return
        }
        guard passwordConfirmation == password else{
            DialogBoxHelper.alert(view: self, withTitle: "Registration is incomplete", andMessage: "Password does not match password confirmation")
            return
        }
        //Verify that the email is not in the database
        guard UsersSet.findUser(email: email!) == nil else{
            DialogBoxHelper.alert(view: self, withTitle: "Register Failed", andMessage: "This email already exists")
            return
        }
        //create a new user
        guard self.selectedRole != nil else{
            return
        }
        let rowOfPromo : Int = Int(self.indexOfRole)
        let promos = UsersSet.findAllPromotion()
        guard promos != nil else{
            self.selectedRole = nil
            DialogBoxHelper.alert(view: self, withTitle: "Registration incomplete", andMessage: "No promotion entered")
            return
        }
        if rowOfPromo < Int((promos?.count)!) {
            let student : Student = Student.createStudent(firstname: firstName!, lastname: lastName!, email: email!, password: password!, accountValidate: false, promotion: promos![rowOfPromo])
            guard UsersSet.addStudent(studentToAdd : student ) else{
                DialogBoxHelper.alert(view: self, withTitle: "Register Failed", andMessage: "Verify your information")
            return
            }
        }
        
        if rowOfPromo == promos?.count{
            let teacher :  Teacher =  Teacher.createTeacher(firstname: firstName!, lastname: lastName!, email: email!, password: password!, accountValidate: false, promotions: nil)
            guard UsersSet.addTeacher(teacherToAdd : teacher ) else{
                DialogBoxHelper.alert(view: self, withTitle: "Register Failed", andMessage: "Verify your information")
            return
            }
        }

        let dismissAction = UIAlertAction(title: "Ok", style: .default, handler: self.dismissSelf)
        DialogBoxHelper.alert(view: self, withTitle: "Register complete", andMessage: "Thank you for your registration ! You can now login and enjoy Zboobee", action: dismissAction)
        return
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var promoPV: UIPickerView!
    var selectedRole: String?
    var pickerData : [String] = []
    
    private func dismissSelf(_ :UIAlertAction) -> Void{
        self.dismiss(animated: true, completion: nil)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let promos = UsersSet.findAllPromotion()
        guard promos != nil else{
            return
        }
        for promo in promos!{
            self.pickerData.append("\(promo.specialty) \(String(promo.graduationYear))")
        }
        self.pickerData.append("Teacher")
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
        print("row : ")
        print(row)
        self.selectedRole = pickerData[row]
        print("role :")
        print(selectedRole)
        self.indexOfRole = row
        return self.selectedRole
        
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
        let emailRegEx = "[A-Z0-9a-z._%+-]+.[A-Z0-9a-z._%+-]+@etu.umontpellier.fr"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
