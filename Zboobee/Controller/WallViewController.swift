//
//  WallViewController.swift
//  Zboobee
//
//  Created by Tom SOMERVILLE-ROBERTS on 22/02/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import UIKit
import CoreData

/// Class that controls the wall (sending, searching messages) view
class WallViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITableViewDataSource,UITableViewDelegate, NSFetchedResultsControllerDelegate, UISearchBarDelegate{

    ///tittleLabel
    @IBOutlet weak var tittleLabel: UILabel!
    ///channelPicker (groups of the user)
    @IBOutlet weak var channelPicker: UIPickerView!
    ///messageToPostLabel
    @IBOutlet weak var messageToPostLabel: UILabel!
    ///messageTF
    @IBOutlet weak var messageTF: UITextField!
    ///messagesTable
    @IBOutlet weak var messagesTable: UITableView!
    ///searchBarEntry
    @IBOutlet weak var searchBarEntry: UISearchBar!
    @IBOutlet weak var titleTF: UITextField!

    //Variables needed to know the group selected
    var indexOfGroup : Int = 0
    var selectedGroup : String = ""
    //Messages in the table view
    var messages: [Message] = []
    
    //Variable user get from the login
    var user : User?
    //segue to show all the details of a message
    let segueShowMessage = "segueShowMessage"
    ///Closure to get the messages we want to see and sort them by date
    fileprivate lazy var messagesFetched : NSFetchedResultsController<Message> = {
        let request :  NSFetchRequest<Message> =  Message.fetchRequest()
        request.predicate = NSPredicate(format: "ANY groups.name == %@", self.selectedGroup)
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Message.date),ascending:false)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()
    
    
    /// action of sending a message, button that verifies every field
    ///
    /// - Parameter sender: no need to know
    @IBAction func sendButton(_ sender: Any) {
        
        //get the text of TF : the message
        let textMessage : String? = self.messageTF.text
        let titleMessage : String? = self.titleTF.text
        //Verify that the message is not empty
        guard textMessage != "" else{
            DialogBoxHelper.alert(view: self, withTitle: "Post incomplete", andMessage: "No Message")
            return
        }
        
        guard titleMessage != "" else{
            DialogBoxHelper.alert(view: self, withTitle: "Post incomplete", andMessage: "No Title")
            return
        }
        
        //Get the groups of the pickerView
        if pickerData[indexOfGroup] == ""{
            DialogBoxHelper.alert(view: self, withTitle: "Pas de groupe", andMessage: "Vous devez selectionner un groupe auquel envoyer")
        }else{
            self.selectedGroup = pickerData[indexOfGroup]
            print(self.selectedGroup)
        }
        //assign the right group to send
        let groups : NSSet = [GroupsSet.findGroupByName(name: self.selectedGroup)!]
        //create the message
        let jour : Date = NSDate.init() as Date
        let message : Message = Message.createMessage(title: titleMessage!, text: textMessage!, date: jour, lengthMax: 500, originator: user!, groups: groups)
        //add a message in the base
        guard MessagesSet.addMessage(messageToAdd: message) else{
            DialogBoxHelper.alert(view: self, withTitle: "Sending message Failed", andMessage: "Verify your message")
            return
        }
        //set the TF to empty
        self.messageTF.text = ""
        self.titleTF.text = ""
        //update the request
        self.updateMessages(predicate: [])
        //inform the user that his message has been posted
        DialogBoxHelper.alert(view: self, withTitle: "Message Posted", andMessage: ("Your message will shortly appear in " + self.pickerData[self.indexOfGroup]))
        //refresh the view to see the new message
        self.messagesTable.reloadData()
        
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
    
    //array of data in the pickerView
    var pickerData : [String] = []
    
    ///Lunch the view
    override func viewDidLoad() {
        //get the user who is logged
        self.user = UserSession.instance.user
        //Verify that the user is get fine
        guard let user = self.user else{
            fatalError("No user selected !!!")
        }
        //Verify that the user has groups
        guard let groups = user.groups else {
            fatalError("No group for this user !!!")
        }
        super.viewDidLoad()
        
        self.channelPicker.dataSource = self
        self.channelPicker.delegate = self
        self.messageTF.delegate = self
        var i = 0
        //initialize the pickerView with his groups
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
        //get the first group selected in the pickerview to see the messages
        self.selectedGroup = self.pickerData[indexOfGroup]
        //update the request and the table
        self.updateMessages(predicate: [])
    }
    
    
    //MARK: - Delegates and data sources
    
    //MARK : Table View
    
    //MARK: Data Sources
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.messagesTable.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! messageTableViewCell
        let message = self.messagesFetched.object(at: indexPath)
        cell.messageLabel.text = message.content
        let userM = message.isPosted
        cell.userLabel.text = userM?.lastname
        cell.titleLabel.text = message.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        guard let section = self.messagesFetched.sections?[section] else {
            fatalError("unexpected section number")
        }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //set the color of the message to see where it comes
        let message = self.messagesFetched.object(at: indexPath)
        if (message.isPosted is Office){
            cell.contentView.backgroundColor = UIColor.magenta
        }
        if (message.isPosted is Teacher ){
            cell.contentView.backgroundColor = UIColor.orange
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //student concerned (line on the table)
        let message = self.messagesFetched.object(at: indexPath)
        let deleteAction  = UITableViewRowAction(style: .default, title: "Delete") { (rowAction, indexPath) in
            self.messagesTable.beginUpdates()
            //TODO delete account in usersSet
            let okDel = Message.deleteMessage(message: message)
            //inform the user that it works or not
            guard (okDel == nil) else {
                DialogBoxHelper.alert(view: self, withTitle: "Deletion Failed", andMessage: "The message still exists")
                return
            }
            DialogBoxHelper.alert(view: self, withTitle: "Deletion Succeed", andMessage: "The message has been deleted")
            self.messagesTable.endUpdates()
            //refresh the table
            self.updateMessages(predicate: [])
        }
        //set the color
        deleteAction.backgroundColor = UIColor.red
        //in functionof the account give 2 differents possibilities
        if self.user is Office{
            return [deleteAction]
        }else{
            return []
        }
    }

    
    //MARK - Picker View
    
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
        self.selectedGroup = self.pickerData[row]
        self.updateMessages(predicate: [])
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK - Navigation
    
    /// prepare the segue
    ///
    /// - Parameters:
    ///   - segue: segue that displays the view
    ///   - sender: no need to know
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object
        if segue.identifier == self.segueShowMessage{
            if let indexPath = self.messagesTable.indexPathForSelectedRow{
                let showMessageViewController = segue.destination as! showMessageViewController
                showMessageViewController.message = self.messagesFetched.object(at: indexPath)
                self.messagesTable.deselectRow(at: indexPath, animated: true)
            }
 
        }
    }

    /// function needed to take off the keyboard
    ///
    /// - Parameter textField: TF that we want to resign
    /// - Returns: always true
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK - NSFecthResultController
    
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
    
    /// update the request and so the table of messages
    ///
    /// - Parameter predicate: predicate of the request
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
    
    //MARK - Search Bar
    
    /// function that update table of messages when a research is made
    ///
    /// - Parameters:
    ///   - _: the search bar
    ///   - textDidChange: change of the text
    func searchBar(_: UISearchBar, textDidChange: String){
        if textDidChange != "" {
            let predicate =  NSPredicate(format: "content CONTAINS[c] %@", textDidChange)
            var predicates : [NSPredicate] = []
            predicates.append(predicate)
            self.updateMessages(predicate: predicates)
        }
        
    }

}
