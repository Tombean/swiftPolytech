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

class FolderController : UIViewController, UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,NSFetchedResultsControllerDelegate,UISearchBarDelegate{
    
    var userloged : User?
    
    @IBOutlet weak var channelPicker: UIPickerView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filesTable: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func permanentToggle(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            self.displayNonPermanentDoc = true
        case 1:
            self.displayNonPermanentDoc = false
        default:
            break
        }
        
    }
    //Variables needed to know the group selected
    var indexOfGroup : Int = 0
    var selectedGroup : String = ""
    //Doc in the table view
    var files: [Document] = []
    var displayNonPermanentDoc : Bool = true
    
    
    fileprivate lazy var filesFetched : NSFetchedResultsController<Document> = {
        let request :  NSFetchRequest<Document> =  Document.fetchRequest()
        request.predicate = NSPredicate(format: "ANY groups.name == %@", self.selectedGroup)
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Document.title),ascending:false)]
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
            fatalError("No user selected!!!")
        }
        guard let groups = user.groups else {
            fatalError("No group for this user !!!")
        }
        super.viewDidLoad()
        self.channelPicker.dataSource = self
        self.channelPicker.delegate = self
        for g in groups  {
            let group = g as! Group
            self.pickerData.append(group.name ?? "no group name")
        }
        self.selectedGroup = self.pickerData[indexOfGroup]
        self.updateFiles(predicate: [])
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
        self.updateFiles(predicate: [])
        
    }
    
    //MARK: Data Sources tableview
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
    
    
    //MARK Search Bar
    
    func searchBar(_: UISearchBar, textDidChange: String){
        if textDidChange != "" {
            let predicate =  NSPredicate(format: "content CONTAINS[c] %@", textDidChange)
            var predicates : [NSPredicate] = []
            predicates.append(predicate)
            self.updateFiles(predicate: predicates)
        }
        
    }
}
