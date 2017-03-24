//
//  UploadController.swift
//  Zboobee
//
//  Created by Laure MARCHAL on 22/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import UIKit

class UploadController : UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var channelPicker: UIPickerView!
    @IBOutlet weak var postTF: UITextField!
    @IBOutlet weak var filePlaceLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    //Variable needed to know the group selected in the pickerView
    var indexOfGroup : Int = 0
    var selectedGroup : String = ""
    //Variable user get from the login
    var userloged : User?
    
    //Action of the uplaod
    @IBAction func shareFileButton(_ sender: Any) {
        let textPost : String? = self.postTF.text
        
        guard textPost != "" else{
            DialogBoxHelper.alert(view: self, withTitle: "Post incomplete", andMessage: "No Message")
            return
        }
        
        //Get the groups of the pickerView
        if pickerData[indexOfGroup] == ""{
            DialogBoxHelper.alert(view: self, withTitle: "Pas de groupe", andMessage: "Vous devez selectionner un groupe auquel partager")
        }else{
            self.selectedGroup = pickerData[indexOfGroup]
        }
        //get the group concerned
        let groups : NSSet = [GroupsSet.findGroupByName(name: self.selectedGroup)]
        //create the file in the database

        //add the file in the base

        self.postTF.text = ""
        DialogBoxHelper.alert(view: self, withTitle: "File Shared", andMessage: "You can now see it in the folder")
    }
    
    
    //sign out
    
    @IBAction func logoutButton(_ sender: Any) {
        UserSession.instance.user = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    //Data in the pickerView, here it will be the groups of the user
    var pickerData : [String] = []
    override func viewDidLoad() {
        self.userloged = UserSession.instance.user
        guard let user = self.userloged else{
            fatalError("No user selected!!!")
        }
        guard let groups = user.groups else {
            fatalError("No group for this user !!!")
        }
        super.viewDidLoad()
        self.channelPicker.dataSource = self
        self.channelPicker.delegate = self
        self.postTF.delegate = self
        var i = 0
        var firstGroupName : String = ""
        for g in groups  {
            let group = g as! Group
            if i == 0 {
                firstGroupName = group.name!
            }
            i += 1
            self.pickerData.append(group.name ?? "no group name")
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    //MARK: Data Sources Picker View
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        self.indexOfGroup = row
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected objec
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
