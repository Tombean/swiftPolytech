//
//  UploadController.swift
//  Zboobee
//
//  Created by Laure MARCHAL on 22/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import UIKit

/// Class that controls the uplaod a new file view
class UploadController : UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    ///urlTF
    @IBOutlet weak var urlTF: UITextField!
    ///titleTF
    @IBOutlet weak var titleTF: UITextField!
    ///channelPicker (groups of the user)
    @IBOutlet weak var channelPicker: UIPickerView!
    //Variable needed to know the group selected in the pickerView
    var indexOfGroup : Int = 0
    var selectedGroup : String = ""
    //Variable user get from the login
    var userloged : User?
    
    /// Action of the uplaod
    ///
    /// - Parameter sender: no need to know
    @IBAction func shareFileButton(_ sender: Any) {
        //get text of all TF
        let title : String? = self.titleTF.text
        let url : String? = self.urlTF.text
        
        //Verify that the title is not empty
        guard title != "" else{
            DialogBoxHelper.alert(view: self, withTitle: "Post incomplete", andMessage: "No Message")
            return
        }
        //Verify that the url is not empty
        guard url != "" else{
            DialogBoxHelper.alert(view: self, withTitle: "No URL", andMessage: "You must write the url of the file")
            return
        }
        
        //verify that url is correct
        guard isCorrectURL(link:url!) else{
            DialogBoxHelper.alert(view: self, withTitle: "URL incorrect", andMessage: "You must write a correct URL (beginning by http, https or www)")
            return
        }
        
        //Get the groups of the pickerView
        if pickerData[indexOfGroup] == ""{
            DialogBoxHelper.alert(view: self, withTitle: "No group", andMessage: "You need to pick a group")
        }else{
            self.selectedGroup = pickerData[indexOfGroup]
        }
        //get the group concerned
        let groups : NSSet = [GroupsSet.findGroupByName(name: self.selectedGroup)]
        //create the file in the database
        let document : Document = Document.createDocument(title: title!, url: url!, originator: userloged!, groups: groups)
        //add a file in the base
        guard DocumentsSet.addDocument(documentToAdd: document) else{
            DialogBoxHelper.alert(view: self, withTitle: "Uploading File Failed", andMessage: "Verify your url")
            return
        }
        //set the TF to null
        self.titleTF.text = ""
        self.urlTF.text = ""
        //inform the user that the file has been added
        DialogBoxHelper.alert(view: self, withTitle: "File Shared", andMessage: "You can now see it in the folder")
    }
    
    
    /// action to sign out : shows 2 possibilities : really sign out on "OK" and cancel this action on "Cancel"
    ///
    /// - Parameter sender: no need to know
    @IBAction func logoutButton(_ sender: Any) {
        let dismissAction = UIAlertAction(title: "Ok", style: .default, handler: self.dismissSelf)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        DialogBoxHelper.alert(view: self, withTitle: "Confirmation", andMessage: "Are you sure you want to log out ?", actions: [dismissAction,cancelAction])
    }
    /// dismiss this screen and go back to the old one
    ///
    /// - Parameter _: action that must be done
    private func dismissSelf(_ :UIAlertAction) -> Void{
        UserSession.instance.user = nil
        self.dismiss(animated: true, completion: nil)
    }
    //Data in the pickerView, here it will be the groups of the user
    var pickerData : [String] = []
    ///Lunch the view
    override func viewDidLoad() {
        //get the user who is logged
        self.userloged = UserSession.instance.user
        //Verify that the user is get fine
        guard let user = self.userloged else{
            fatalError("No user selected!!!")
        }
        //Verify that the user has groups
        guard let groups = user.groups else {
            fatalError("No group for this user !!!")
        }
        super.viewDidLoad()
        self.channelPicker.dataSource = self
        self.channelPicker.delegate = self
        self.titleTF.delegate = self
        self.urlTF.delegate = self
        //initialize the pickerView with his groups
        for g in groups  {
            let group = g as! Group
            self.pickerData.append(group.name ?? "no group name")
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    //MARK: - Delegates and data sources
    
    //MARK -  Picker View
    
    //MARK: Data Sources
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
    /// function needed to take off the keyboard
    ///
    /// - Parameter textField: TF that we want to resign
    /// - Returns: always true
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    /// says if an url is correct
    ///
    /// - Parameter link: url in the TF to test
    /// - Returns: true if the url is correct format
    func isCorrectURL(link:String)->Bool{
        let urlRegEx = "^((http|https)://){0,1}www.+[A-Z0-9a-z._%+-/]+.[A-Za-z]"

        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        return urlTest.evaluate(with: link)
    }
    
}
