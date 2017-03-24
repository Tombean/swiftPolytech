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

class NewEventController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    
    var userloged : User?
    //Variables needed to know the group selected
    var indexOfGroup : Int = 0
    var selectedGroup : String = ""
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleTF: UITextField!
    
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var durationTF: UITextField!
    @IBOutlet weak var descTF: UITextField!
    @IBOutlet weak var groupPV: UIPickerView!
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func validateButton(_ sender: Any) {
        let title : String? = self.titleTF.text
        let desc : String? = self.descTF.text
        let duration : String? = self.durationTF.text
        let location : String? = self.locationTF.text
        
        guard title != "" else{
            DialogBoxHelper.alert(view: self, withTitle: "Post incomplete", andMessage: "No event title")
            return
        }
        guard desc != "" else{
            DialogBoxHelper.alert(view: self, withTitle: "Post incomplete", andMessage: "No event title")
            return
        }
        guard location != "" else{
            DialogBoxHelper.alert(view: self, withTitle: "Post incomplete", andMessage: "No event location")
            return
        }
        guard duration != "" else{
            DialogBoxHelper.alert(view: self, withTitle: "Post incomplete", andMessage: "No event duration")
            return
        }
        //convert duration in Int16
        let dure : Int16 = Int16(duration!)!
        //Get the groups of the pickerView
        if pickerData[indexOfGroup] == ""{
            DialogBoxHelper.alert(view: self, withTitle: "Pas de groupe", andMessage: "Vous devez selectionner un groupe")
        }else{
            self.selectedGroup = pickerData[indexOfGroup]
            print(self.selectedGroup)
        }
        
        let group = GroupsSet.findGroupByName(name: self.selectedGroup)!
        //create the message
        let dateEvent = datePicker.date
        let event : Event = Event.createEvent(title:title!,description:desc!,duration:dure,location:location!,date: dateEvent,originator:userloged!,group: group)
        //add a message in the base
        guard EventsSet.addEvent(eventToAdd: event) else{
            DialogBoxHelper.alert(view: self, withTitle: "Posting event Failed", andMessage: "Verify your event")
            return
        }
        
        let dismissAction = UIAlertAction(title: "Ok", style: .default, handler: self.dismissSelf)
        DialogBoxHelper.alert(view: self, withTitle: "Event posted !", andMessage: "You can now see the event in the table", action: dismissAction)
        return
        
    }
    private func dismissSelf(_ :UIAlertAction) -> Void{
        self.dismiss(animated: true, completion: nil)
    }
    var pickerData : [String] = []
    
    override func viewDidLoad() {
        self.userloged = UserSession.instance.user
        guard let user = self.userloged else{
            fatalError("No user selected !!!")
        }
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
        guard firstGroupName != "" else {
            fatalError("No first group")
        }
        self.selectedGroup = self.pickerData[indexOfGroup]

        
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
        print("Dans le picker view, on est sur : "+self.pickerData[row])
        self.selectedGroup = self.pickerData[row]
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
