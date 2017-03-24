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

class CalendarController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate, UISearchBarDelegate{
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var channelPicker: UIPickerView!
    @IBOutlet weak var eventsTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //Variables needed to know the group selected
    var indexOfGroup : Int = 0
    var selectedGroup : String = ""
    //events in the table view
    var events: [Event] = []
    //Variable user get from the login
    var userloged : User?
    
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
        self.channelPicker.dataSource = self
        self.channelPicker.delegate = self
        
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
        
        self.updateEvents(predicate: [])
        // Do any additional setup after loading the view, typically from a nib.

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //self.updateMessages()
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
    
    //MARK Search Bar
    
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
