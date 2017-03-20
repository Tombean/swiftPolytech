//
//  WallViewController.swift
//  Zboobee
//
//  Created by Tom SOMERVILLE-ROBERTS on 22/02/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

// A LIRE

import UIKit

class WallViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var channelPicker: UIPickerView!
    var selectedGroups : String?
    @IBOutlet weak var messageToPostLabel: UILabel!
    @IBOutlet weak var messageTF: UITextField!
    @IBOutlet weak var messagesTable: UITableView!
    @IBOutlet weak var searchToolbar: UIToolbar!
    @IBOutlet weak var menuToolbar: UIToolbar!
    var indexOfGroup : Int = 0
    
    var messages: [Message] = []
    
    //Variable user get from the login
    var user : User? = nil
    
    @IBAction func sendButton(_ sender: Any) {
        
        let textMessage : String? = self.messageTF.text
        
        guard textMessage != "" else{
            DialogBoxHelper.alert(view: self, withTitle: "Post incomplete", andMessage: "No Message")
            return
        }
//        let lengthMsg : Int? = textMessage?.lengthOfBytes(using: UTF8)
//        guard lengthMsg != nil else{
//            DialogBoxHelper.alert(view: self, withTitle: "Post wrong", andMessage: "The message is empty")
//
//            return
//        }
//        guard lengthMsg <= 500 else{
//            DialogBoxHelper.alert(view: self, withTitle: "Post wrong", andMessage: "The message does more than 500 charaters")
//            return
//        }
        
        //Get the groups of the pickerView
        guard self.selectedGroups != nil else{
            return
        }
        let baseGroups = GroupsSet.findAllGroups()
        //very that there are groups in the database
        guard baseGroups != nil else{
            self.selectedGroups = nil
            DialogBoxHelper.alert(view: self, withTitle: "Data incomplete", andMessage: "No groups")
            return
        }
        //create the good groups tab
        var groups : NSSet
        switch(self.selectedGroups!){
        case "All":
            groups = (user?.groups)!
        case "Class" :
            groups = [GroupsSet.findGroupByName(name: "Students")!]
        case "Class - Teachers" :
            groups = [GroupsSet.findGroupByName(name: "IG3 - Teachers")!,
                      GroupsSet.findGroupByName(name: "IG4 - Teachers")!,
                GroupsSet.findGroupByName(name: "IG5 - Teachers")!]
        case "Class - Office" :
            groups = [GroupsSet.findGroupByName(name: "Office")!]
        default :
            groups = (user?.groups)!
        }
        //create the message
        let jour : Date = NSDate.init() as Date
        let message : Message = Message.createMessage(title: "msg1", text: textMessage!, date: jour, lengthMax: 500, originator: user!, groups: groups)
        guard MessagesSet.addMessage(messageToAdd: message) else{
            DialogBoxHelper.alert(view: self, withTitle: "Sending message Failed", andMessage: "Verify your message")
            return
        }
        DialogBoxHelper.alert(view: self, withTitle: "Message Posted", andMessage: "You can now see it in the table view")
    }
    
    
    @IBAction func logoutButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Temporary :  needs to be changed with channel allowed from DB
    let pickerData = ["All","Class","Class - Teachers","Class - Office"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.channelPicker.dataSource = self
        self.channelPicker.delegate = self
        self.messageTF.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        guard MessagesSet.findAllMessages() != nil else{
            messages = []
            DialogBoxHelper.alert(view: self, withTitle: "No messages", andMessage: "There are no messages sent")
            return
        }
        messages = MessagesSet.findAllMessages()!
    }
    
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.messagesTable.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! messageTableViewCell
        cell.messageLabel.text = self.messages[indexPath.row].content!
        let userM = self.messages[indexPath.row].isPosted!
        cell.userLabel.text = userM.mailUniv
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.messages.count
    }
    
    //MARK: Data Sources Picker View
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
        self.selectedGroups = pickerData[row]
        print("role :")
        print(selectedGroups)
        self.indexOfGroup = row
        return self.selectedGroups
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
