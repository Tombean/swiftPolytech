//
//  FolderController.swift
//  Zboobee
//
//  Created by Laure MARCHAL on 22/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/// Class that controls the Folder (files) view
class FolderController : UIViewController, UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,NSFetchedResultsControllerDelegate,UISearchBarDelegate{
    
    //Variable user get from the login
    var userloged : User?
    
    ///channelPicker (groups of the user)
    @IBOutlet weak var channelPicker: UIPickerView!
    ///titleLabel
    @IBOutlet weak var titleLabel: UILabel!
    ///searchBar
    @IBOutlet weak var searchBar: UISearchBar!
    ///filesTable
    @IBOutlet weak var filesTable: UITableView!
    ///segmentedControl (permanent or other files)
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    /// set the files in function of position
    ///
    /// - Parameter sender: no need to know
    @IBAction func permanentToggle(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            self.displayNonPermanentDoc = true
            self.updateFiles(predicate: [])
        case 1:
            self.displayNonPermanentDoc = false
            self.updateFiles(predicate: [])
        default:
            break
        }
        
    }
    //Variables needed to know the group selected
    var indexOfGroup : Int = 0
    var selectedGroup : String = ""
    //Doc in the table view
    var files: [Document] = []
    //bool to say wich file to display
    var displayNonPermanentDoc : Bool = true
    
    ///Closure to get the files we want to see and sort them by title
    fileprivate lazy var filesFetched : NSFetchedResultsController<Document> = {
        let request :  NSFetchRequest<Document> =  Document.fetchRequest()
        request.predicate = NSPredicate(format: "ANY groups.name == %@", self.selectedGroup)
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Document.title),ascending:false)]
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
            fatalError("No user selected!!!")
        }
        //Verify that the user has groups
        guard let groups = user.groups else {
            fatalError("No group for this user !!!")
        }
        super.viewDidLoad()
        self.channelPicker.dataSource = self
        self.channelPicker.delegate = self
        //initialize the pickerView with his groups
        for g in groups  {
            let group = g as! Group
            self.pickerData.append(group.name ?? "no group name")
        }
        //get the first group selected in the pickerview to see the files
        self.selectedGroup = self.pickerData[indexOfGroup]
        //update the request and the table
        self.updateFiles(predicate: [])
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
        print("Dans le picker view, on est sur : "+self.pickerData[row])
        self.selectedGroup = self.pickerData[row]
        self.updateFiles(predicate: [])
        
    }
    
    //MARK -  Table View
    
    //MARK: Data Sources
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //self.updateMessages()
        let cell = self.filesTable.dequeueReusableCell(withIdentifier: "fileCell", for: indexPath) as! fileTableViewCell
        let file = self.filesFetched.object(at: indexPath)
        let user = file.isPosted
        cell.title.text = file.title!
        cell.urlToDoc.text = file.url!
        // Displays the cell according to the toggle
        if self.displayNonPermanentDoc == false && user is Student{
            cell.isHidden = true
        }else{
            cell.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        guard let section = self.filesFetched.sections?[section] else {
            fatalError("unexpected section number")
        }
        return section.numberOfObjects
    }
    //MARK NSFecthResultController
    
    //MARK: - Controller methods
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.filesTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.filesTable.endUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?){
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath{
                self.filesTable.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath{
                self.filesTable.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
    }
    
    /// update the request and so the table of files
    ///
    /// - Parameter predicate: predicate of the request
    func updateFiles(predicate : [NSPredicate]){
        if predicate == []{
            self.filesFetched = NSFetchResultUpdater.updateFilePredicate(predicate: NSPredicate(format: "ANY groups.name == %@", self.selectedGroup))
        }else{
            var predicates : [NSPredicate] = []
            for p in predicate{
                predicates.append(p)
            }
            predicates.append(NSPredicate(format: "ANY groups.name == %@", self.selectedGroup))
            self.filesFetched = NSFetchResultUpdater.updateFilePredicate(predicates: predicates)
        }
        do{
            try self.filesFetched.performFetch()
            self.filesTable.reloadData()
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
            self.updateFiles(predicate: predicates)
        }
        
    }
}
