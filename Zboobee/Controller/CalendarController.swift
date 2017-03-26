//
//  CalendarController.swift
//  Zboobee
//
//  Created by polytech on 24/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/// Class that controls the calendar (table of events) view
class CalendarController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate, UISearchBarDelegate{
    
    ///titleLabel
    @IBOutlet weak var titleLabel: UILabel!
    ///channelPicker (groups of the user)
    @IBOutlet weak var channelPicker: UIPickerView!
    ///eventsTable
    @IBOutlet weak var eventsTable: UITableView!
    ///searchBar
    @IBOutlet weak var searchBar: UISearchBar!
    
    //Variables needed to know the group selected
    var indexOfGroup : Int = 0
    var selectedGroup : String = ""
    //events in the table view
    var events: [Event] = []
    //Variable user get from the login
    var userloged : User?
    
    ///Closure to get the events we want to see and sort them by date
    fileprivate lazy var eventsFetched : NSFetchedResultsController<Event> = {
        let request :  NSFetchRequest<Event> =  Event.fetchRequest()
        //request.predicate = NSPredicate(format: "ANY group.name == %@", self.selectedGroup)
        let predicateGroup = NSPredicate(format: "ANY group.name == %@", self.selectedGroup)
        let predicateTime =  NSPredicate(format: "date > %@", Helper.getCurrentDate())
        var predicates : [NSPredicate] = []
        predicates.append(predicateGroup)
        predicates.append(predicateTime)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Event.date),ascending:false)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()
    
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
        self.channelPicker.dataSource = self
        self.channelPicker.delegate = self
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
        //get the first group selected in the pickerview to see the events
        self.selectedGroup = self.pickerData[indexOfGroup]
        //update the request and the table
        self.updateEvents(predicate: [])

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    //MARK: - Delegates and data sources
    
    // MARK - tableview
    
    //MARK: Data Sources
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.eventsTable.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! eventTableViewCell
        let event = self.eventsFetched.object(at: indexPath)
        cell.title.text = event.title!
        cell.duration.text = event.duration
        cell.date.text = Helper.getFormattedDate(date:event.date as! Date)
        cell.location.text = event.place!
        let userE = event.isCreated!
        cell.user.text = userE.lastname
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        guard let section = self.eventsFetched.sections?[section] else {
            fatalError("unexpected section number")
        }
        return section.numberOfObjects
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //student concerned (line on the table)
        let event = self.eventsFetched.object(at: indexPath)
        let deleteAction  = UITableViewRowAction(style: .default, title: "Delete") { (rowAction, indexPath) in
            self.eventsTable.beginUpdates()
            //TODO delete account in usersSet
            let okDel = Event.deleteEvent(event: event)
            //inform the user that it works or not
            guard (okDel == nil) else {
                DialogBoxHelper.alert(view: self, withTitle: "Deletion Failed", andMessage: "The event still exists")
                return
            }
            DialogBoxHelper.alert(view: self, withTitle: "Deletion Succeed", andMessage: "The event has been deleted")
            self.eventsTable.endUpdates()
            //refresh the table
            self.updateEvents(predicate: [])
        }
        //set the color
        deleteAction.backgroundColor = UIColor.red
        //in functionof the account give 2 differents possibilities
        if self.userloged is Office{
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
        print("Dans le picker view, on est sur : "+self.pickerData[row])
        self.selectedGroup = self.pickerData[row]
        self.updateEvents(predicate: [])
        
    }

    //MARK NSFecthResultController
    
    //MARK: - Controller methods
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.eventsTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.eventsTable.endUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?){
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath{
                self.eventsTable.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath{
                self.eventsTable.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
    }
    
    /// update the request and so the table of events
    ///
    /// - Parameter predicate: predicate of the request
    func updateEvents(predicate : [NSPredicate]){
        if predicate == []{
            self.eventsFetched = NSFetchResultUpdater.updateEventPredicate(predicate: NSPredicate(format: "ANY group.name == %@", self.selectedGroup))
        }else{
            var predicates : [NSPredicate] = []
            for p in predicate{
                predicates.append(p)
            }
            predicates.append(NSPredicate(format: "ANY group.name == %@", self.selectedGroup))
            self.eventsFetched = NSFetchResultUpdater.updateEventPredicate(predicates: predicates)
        }
        do{
            try self.eventsFetched.performFetch()
            self.eventsTable.reloadData()
        }catch let error as NSError{
            DialogBoxHelper.alert(view: self, error: error)
        }
    }
    
    //MARK - Search Bar
    
    /// function that update table of events when a research is made
    ///
    /// - Parameters:
    ///   - _: the search bar
    ///   - textDidChange: change of the text
    func searchBar(_: UISearchBar, textDidChange: String){
        if textDidChange != "" {
            let predicate =  NSPredicate(format: "title CONTAINS[c] %@", textDidChange)
            let predicateTime =  NSPredicate(format: "date > %@", Helper.getCurrentDate())
            var predicates : [NSPredicate] = []
            predicates.append(predicate)
            predicates.append(predicateTime)
            self.updateEvents(predicate: predicates)
        }
        
    }


}
