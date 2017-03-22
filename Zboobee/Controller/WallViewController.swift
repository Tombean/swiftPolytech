//
//  WallViewController.swift
//  Zboobee
//
//  Created by Tom SOMERVILLE-ROBERTS on 22/02/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

// A LIRE

import UIKit
import CoreData

class WallViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITableViewDataSource,UITableViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var channelPicker: UIPickerView!
    @IBOutlet weak var messageToPostLabel: UILabel!
    @IBOutlet weak var messageTF: UITextField!
    @IBOutlet weak var messagesTable: UITableView!
    @IBOutlet weak var searchToolbar: UIToolbar!
    @IBOutlet weak var menuToolbar: UIToolbar!
    var indexOfGroup : Int = 0
    var selectedGroup : String = ""
    var messages: [Message] = []
    
    //Variable user get from the login
    var user : User? = nil
    
    fileprivate lazy var messagesFetched : NSFetchedResultsController<Message> = {
        let request :  NSFetchRequest<Message> =  Message.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Message.date),ascending:false)]
        request.predicate = NSPredicate(format: "ANY groups.name == %@", self.selectedGroup)
        let fetchResultController =  NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()
    
    @IBAction func sendButton(_ sender: Any) {
        
        let textMessage : String? = self.messageTF.text
        
        guard textMessage != "" else{
            DialogBoxHelper.alert(view: self, withTitle: "Post incomplete", andMessage: "No Message")
            return
        }
        
        //Get the groups of the pickerView
        if pickerData[indexOfGroup] == ""{
            DialogBoxHelper.alert(view: self, withTitle: "Pas de groupe", andMessage: "Vous devez selectionner un groupe auquel envoyer")
        }else{
            self.selectedGroup = pickerData[indexOfGroup]
        }
        
        let groups : NSSet = [GroupsSet.findGroupByName(name: self.selectedGroup)]
        //create the message
        let jour : Date = NSDate.init() as Date
        let message : Message = Message.createMessage(title: "msg1", text: textMessage!, date: jour, lengthMax: 500, originator: user!, groups: groups)
        //add a message in the base
        guard MessagesSet.addMessage(messageToAdd: message) else{
            DialogBoxHelper.alert(view: self, withTitle: "Sending message Failed", andMessage: "Verify your message")
            return
        }
        self.messageTF.text = ""
        DialogBoxHelper.alert(view: self, withTitle: "Message Posted", andMessage: "You can now see it in the table view")
        self.messagesTable.reloadData()
        
    }
    
    
    // Temporary :  needs to be changed with channel allowed from DB
    
    var pickerData : [String] = []
    
    
    override func viewDidLoad() {
        guard let user = self.user else{
            fatalError("No user selected!!!")
        }
        guard let groups = user.groups else {
            fatalError("No group for this user !!!")
        }
        super.viewDidLoad()
        self.channelPicker.dataSource = self
        self.channelPicker.delegate = self
        self.messageTF.delegate = self
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
        // Do any additional setup after loading the view, typically from a nib.
        self.messages = MessagesSet.findAllMessagesForGroup(groupName: firstGroupName) ?? []
    }
    
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.messagesTable.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! messageTableViewCell
        
        cell.messageLabel.text = self.messages[indexPath.row].content!
        let userM = self.messages[indexPath.row].isPosted!
        cell.userLabel.text = userM.lastname
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
        self.messages = MessagesSet.findAllMessagesForGroup(groupName: pickerData[row]) ?? []
        self.messagesTable.reloadData()
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
