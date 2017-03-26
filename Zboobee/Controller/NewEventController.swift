//
//  CalendarController.swift
//  Zboobee
//
//  Created by Laure MARCHAL on 22/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/// Class that controls the event addition view
class NewEventController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    //Variable user get from the login
    var userloged : User?
    //Variables needed to know the group selected
    var indexOfGroup : Int = 0
    var selectedGroup : String = ""
    
    ///datePicker
    @IBOutlet weak var datePicker: UIDatePicker!
    ///titleTF
    @IBOutlet weak var titleTF: UITextField!
    ///locationTF
    @IBOutlet weak var locationTF: UITextField!
    ///durationTF
    @IBOutlet weak var durationTF: UITextField!
    ///descTF
    @IBOutlet weak var descTF: UITextField!
    ///groupPV (groups of the user)
    @IBOutlet weak var groupPV: UIPickerView!
    
    
    /// action to return to the old screen and cancel the addition
    ///
    /// - Parameter sender: no need to know
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// action to validate a event post
    ///
    /// - Parameter sender: no need to know
    @IBAction func validateButton(_ sender: Any) {
        
        //get the text of all TF
        let title : String? = self.titleTF.text
        let desc : String? = self.descTF.text
        let duration : String? = self.durationTF.text
        let location : String? = self.locationTF.text
        
        //Verify that the title is not empty
        guard title != "" else{
            DialogBoxHelper.alert(view: self, withTitle: "Post incomplete", andMessage: "No event title")
            return
        }
        //Verify that the description is not empty
        guard desc != "" else{
            DialogBoxHelper.alert(view: self, withTitle: "Post incomplete", andMessage: "No event title")
            return
        }
        //Verify that the location is not empty
        guard location != "" else{
            DialogBoxHelper.alert(view: self, withTitle: "Post incomplete", andMessage: "No event location")
            return
        }
        //Verify that the duration is not empty
        guard duration != "" else{
            DialogBoxHelper.alert(view: self, withTitle: "Post incomplete", andMessage: "No event duration")
            return
        }
        //get the date enter in the datepicker
        let dateEvent : Date = datePicker.date
        //Verify that the date entered is in the future
        guard dateEvent >= Date() else{
            DialogBoxHelper.alert(view: self, withTitle: "Date incorrect", andMessage: "The date must be in the future")
            return
        }
        //Get the groups of the pickerView
        if pickerData[indexOfGroup] == ""{
            DialogBoxHelper.alert(view: self, withTitle: "Pas de groupe", andMessage: "Vous devez selectionner un groupe")
        }else{
            self.selectedGroup = pickerData[indexOfGroup]
            print(self.selectedGroup)
        }
        //assign the right group to send
        let group = GroupsSet.findGroupByName(name: self.selectedGroup)!
        //create the event
        let event : Event = Event.createEvent(title:title!,description:desc!,duration:duration!,location:location!,date: dateEvent,originator:userloged!,group: group)
        //add an event in the base
        guard EventsSet.addEvent(eventToAdd: event) else{
            DialogBoxHelper.alert(view: self, withTitle: "Posting event Failed", andMessage: "Verify your event")
            return
        }
        
        //shows a box to inform that the vent has been posted and go back to the calendar
        let dismissAction = UIAlertAction(title: "Ok", style: .default, handler: self.dismissSelf)
        DialogBoxHelper.alert(view: self, withTitle: "Event posted !", andMessage: "You can now see the event in the table", action: dismissAction)
        return
        
    }
    /// dismiss this screen and go back to the old one
    ///
    /// - Parameter _: action that must be done
    private func dismissSelf(_ :UIAlertAction) -> Void{
        self.dismiss(animated: true, completion: nil)
    }
    //array of data in the pickerView
    var pickerData : [String] = []
    
    ///Lunch the view
    override func viewDidLoad() {
        
        //get the user who is logged
        self.userloged = UserSession.instance.user
        //Verify that the user is get fine
        guard let user = self.userloged else{
            fatalError("No user selected !!!")
        }
        //Verify that the user has groups
        guard let groups = user.groups else {
            fatalError("No group for this user !!!")
        }
        super.viewDidLoad()
        self.groupPV.dataSource = self
        self.groupPV.delegate = self
        self.locationTF.delegate = self
        self.titleTF.delegate = self
        self.durationTF.delegate = self
        self.descTF.delegate = self
        //initialize the pickerView with his groups
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
        //Verify that there is at least one group
        guard firstGroupName != "" else {
            fatalError("No first group")
        }
        //get the first group selected in the pickerview
        self.selectedGroup = self.pickerData[indexOfGroup]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    //MARK: - Delegates and data sources
    
    //MARK : picker View
    
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
        print("Dans le picker view, on est sur : "+self.pickerData[row])
        self.selectedGroup = self.pickerData[row]
        
    }
    /// function needed to take off the keyboard
    ///
    /// - Parameter textField: TF that we want to resign
    /// - Returns: always true
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
