//
//  RegistrationController.swift
//  Zboobee
//
//  Created by Tom SOMERVILLE-ROBERTS on 27/02/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import UIKit

class RegistrationController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmpasswordTF: UITextField!
    @IBOutlet weak var validateButton: UIButton!
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
        
}
