//
    //  RegistrationController.swift
    //  Zboobee
    //
    //  Created by Tom SOMERVILLE-ROBERTS on 27/02/2017.
    //  Copyright © 2017 Laure MARCHAL. All rights reserved.
    //

import UIKit
import CoreData

/// Class that controls the registration view
class RegistrationController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    ///firstNameTF
    @IBOutlet weak var firstNameTF: UITextField!
    ///lastNameTF
    @IBOutlet weak var lastNameTF: UITextField!
    ///emailTF
    @IBOutlet weak var emailTF: UITextField!
    ///passwordTF
    @IBOutlet weak var passwordTF: UITextField!
    ///confirmedpasswordTF
    @IBOutlet weak var confirmpasswordTF: UITextField!
    ///index of the role selected on the pickerView
    var indexOfRole : Int = 0
    
    /// validate button to verify all the TF to register
    ///
    /// - Parameter sender: no need to know
    @IBAction func validateButton(_ sender: Any) {
    
        //get the text of the TF
        let firstName : String? = self.firstNameTF.text
        let lastName : String? = self.lastNameTF.text
        let email : String? = self.emailTF.text
        let password : String? = self.passwordTF.text
        let passwordConfirmation : String? = self.confirmpasswordTF.text

        //Verify that all the fields are not empty
        guard firstName != "" else{
            DialogBoxHelper.alert(view: self, withTitle: "Registration is incomplete", andMessage: "No first name")
            return
        }
        guard lastName != "" else{
            DialogBoxHelper.alert(view: self, withTitle: "Registration is incomplete", andMessage: "No last name")
            return
        }
        //Verify the format of the email
        guard email != "" && isValidEmail(testStr: email!) else{
            DialogBoxHelper.alert(view: self, withTitle: "Registration is incomplete", andMessage: "No email or invalid format : please use your @etu.umontpellier.fr email address")
            return
        }
        //Verify that the password makes more than 6 characters
        guard password != "" && (password?.characters.count)! >= 6 else{
            DialogBoxHelper.alert(view: self, withTitle: "Registration is incomplete", andMessage: "No password, password must contain at least 6 characters")
            return
        }
        //Verify that the confirmedpassword makes more than 6 characters
        guard passwordConfirmation != "" && (passwordConfirmation?.characters.count)! >= 6 else{
           DialogBoxHelper.alert(view: self, withTitle: "Registration is incomplete", andMessage: "No password confirmation, password confirmation must contain at least 6 characters")
            return
        }
        //Verify that the password corresponds to the confirmedpassword-
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
        //assigs the promo and the role
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
            print("creating new techer")
            let teacher :  Teacher =  Teacher.createTeacher(firstname: firstName!, lastname: lastName!, email: email!, password: password!, accountValidate: false, promotions: nil)
            guard UsersSet.addTeacher(teacherToAdd : teacher ) else{
                DialogBoxHelper.alert(view: self, withTitle: "Register Failed", andMessage: "Verify your information")
            return
            }
        }
        //display a box if the registration works and on the ok the box is dismiss to go to the login view
        let dismissAction = UIAlertAction(title: "Ok", style: .default, handler: self.dismissSelf)
        DialogBoxHelper.alert(view: self, withTitle: "Register complete", andMessage: "Thank you for your registration ! You can now login and enjoy Zboobee", action: dismissAction)
        return
    }
    
    
    /// cancel the registration and go back to the login view
    ///
    /// - Parameter sender: no need to know
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //pickerview with roles
    @IBOutlet weak var promoPV: UIPickerView!
    //Variable of the role selected on the pickerView
    var selectedRole: String?
    //Variable for the data in the pickerview
    var pickerData : [String] = []
    
    
    /// dismiss this screen and go back to the old one
    ///
    /// - Parameter _: action that must be done
    private func dismissSelf(_ :UIAlertAction) -> Void{
        self.dismiss(animated: true, completion: nil)
    }
    ///Lunch the view
    override func viewDidLoad() {
        super.viewDidLoad()
        //initialize the pickerView
        let promos = UsersSet.findAllPromotion()
        guard promos != nil else{
            return
        }
        for promo in promos!{
            self.pickerData.append("\((promo.specialty)!) \(String(promo.graduationYear))")
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
    //MARK - Picker View
    
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
        self.indexOfRole = row
        return self.selectedRole
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object
    }
    
    /// function needed to take off the keyboard
    ///
    /// - Parameter textField: TF that we want to resign
    /// - Returns: always true
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /// tests if the email format is ok
    ///
    /// - Parameter testStr: email tested
    /// - Returns: true if the email format is ok and false if not
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+.[A-Z0-9a-z._%+-]+@etu.umontpellier.fr"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
