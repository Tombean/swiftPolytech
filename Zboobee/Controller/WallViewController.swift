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

class WallViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITableViewDataSource,UITableViewDelegate, NSFetchedResultsControllerDelegate, UISearchBarDelegate{

    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var channelPicker: UIPickerView!
    @IBOutlet weak var messageToPostLabel: UILabel!
    @IBOutlet weak var messageTF: UITextField!
    @IBOutlet weak var messagesTable: UITableView!
    @IBOutlet weak var searchBarEntry: UISearchBar!

    //Variables needed to know the group selected
    var indexOfGroup : Int = 0
    var selectedGroup : String = ""
    //Messages in the table view
    var messages: [Message] = []
    
    //Variable user get from the login
    var user : User?
    
    fileprivate lazy var messagesFetched : NSFetchedResultsController<Message> = {
        let request :  NSFetchRequest<Message> =  Message.fetchRequest()
        request.predicate = NSPredicate(format: "ANY groups.name == %@", self.selectedGroup)
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Message.date),ascending:false)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
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
            print(self.selectedGroup)
        }
        
        let groups : NSSet = [GroupsSet.findGroupByName(name: self.selectedGroup)!]
        //create the message
        let jour : Date = NSDate.init() as Date
        let message : Message = Message.createMessage(title: "msg1", text: textMessage!, date: jour, lengthMax: 500, originator: user!, groups: groups)
        //add a message in the base
        guard MessagesSet.addMessage(messageToAdd: message) else{
            DialogBoxHelper.alert(view: self, withTitle: "Sending message Failed", andMessage: "Verify your message")
            return
        }
        self.messageTF.text = ""
        self.updateMessages(predicate: [])
        DialogBoxHelper.alert(view: self, withTitle: "Message Posted", andMessage: ("Your message will shortly appear in " + self.pickerData[self.indexOfGroup]))
        self.messagesTable.reloadData()
        
    }
    
    //sign out 
    
    @IBAction func logoutButton(_ sender: Any) {
        let dismissAction = UIAlertAction(title: "Ok", style: .default, handler: self.dismissSelf)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        DialogBoxHelper.alert(view: self, withTitle: "Confirmation", andMessage: "Are you sure you want to log out ?", actions: [dismissAction,cancelAction])
    }
    
    private func dismissSelf(_ :UIAlertAction) -> Void{
        UserSession.instance.user = nil
        self.dismiss(animated: true, completion: nil)
    }
    // Temporary :  needs to be changed with channel allowed from DB
    
    var pickerData : [String] = []
    
    
    override func viewDidLoad() {
        self.user = UserSession.instance.user
        guard let user = self.user else{
            fatalError("No user selected !!!")
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
        guard firstGroupName != "" else {
            fatalError("No first group")
        }
        self.selectedGroup = self.pickerData[indexOfGroup]
        self.updateMessages(predicate: [])
        // Do any additional setup after loading the view, typically from a nib.
        //self.messages = MessagesSet.findAllMessagesForGroup(groupName: firstGroupName) ?? []
    }
    
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //self.updateMessages()
        let cell = self.messagesTable.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! messageTableViewCell
        let message = self.messagesFetched.object(at: indexPath)
        cell.messageLabel.text = message.content
        let userM = message.isPosted
        cell.userLabel.text = userM?.lastname
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        guard let section = self.messagesFetched.sections?[section] else {
            fatalError("unexpected section number")
        }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let message = self.messagesFetched.object(at: indexPath)
        if (message.isPosted is Teacher || message.isPosted is Office){
            cell.contentView.backgroundColor = UIColor.magenta
        }
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
        self.updateMessages(predicate: [])
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK NSFecthResultController
    
    //MARK: - Controller methods
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.messagesTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.messagesTable.endUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?){
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath{
                self.messagesTable.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath{
                self.messagesTable.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
    }
    
    func updateMessages(predicate : [NSPredicate]){
        if predicate == []{
            self.messagesFetched = NSFetchResultUpdater.updateMessagePredicate(predicate: NSPredicate(format: "ANY groups.name == %@", self.selectedGroup))
        }else{
            var predicates : [NSPredicate] = []
            for p in predicate{
                predicates.append(p)
            }
            predicates.append(NSPredicate(format: "ANY groups.name == %@", self.selectedGroup))
            self.messagesFetched = NSFetchResultUpdater.updateMessagePredicate(predicates: predicates)
        }
        do{
            try self.messagesFetched.performFetch()
            self.messagesTable.reloadData()
        }catch let error as NSError{
            DialogBoxHelper.alert(view: self, error: error)
        }
    }
    
    //MARK Search Bar
    
    func searchBar(_: UISearchBar, textDidChange: String){
        if textDidChange != "" {
            let predicate =  NSPredicate(format: "content CONTAINS[c] %@", textDidChange)
            var predicates : [NSPredicate] = []
            predicates.append(predicate)
            self.updateMessages(predicate: predicates)
        }
        
    }

    
}
