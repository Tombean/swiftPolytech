//
//  SettingsTeachersController.swift
//  Zboobee
//
//  Created by Laure MARCHAL on 25/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/// Class that controls the settings account of Teachers view
class SettingsTeachersController : UIViewController, UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate{
    
    ///titleteachers
    @IBOutlet weak var titleteachers: UILabel!
    ///teachTable
    @IBOutlet weak var teachTable: UITableView!
    
    /// Stop the action and return to the old view
    ///
    /// - Parameter sender: no need to know
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    ///Closure to get the teachers we want to see and sort them by lastname
    fileprivate lazy var teachersFetched : NSFetchedResultsController<Teacher> = {
        let request :  NSFetchRequest<Teacher> =  Teacher.fetchRequest()
        //request.predicate = NSPredicate(format: "accountValidate == false")
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Teacher.lastname),ascending:true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()

    //Launch the view
    override func viewDidLoad() {
        super.viewDidLoad()
        //update the request and the table
        self.updateTeachers(predicate: [])
    
    }
    
    //MARK: - Delegates and data sources
    
    //MARK : Table View
    
    //MARK: Data Sources
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //self.updateMessages()
        let cell = self.teachTable.dequeueReusableCell(withIdentifier: "teacherCell", for: indexPath) as! teacherTableViewCell
        let teacher : Teacher = self.teachersFetched.object(at: indexPath)
        cell.lastname.text = teacher.lastname
        cell.firstname.text = teacher.firstname
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let teacher = self.teachersFetched.object(at: indexPath)
        if teacher.accountValidate == false{
            cell.contentView.backgroundColor = UIColor.orange
        }else{
            cell.contentView.backgroundColor = UIColor.magenta
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        guard let section = self.teachersFetched.sections?[section] else {
            fatalError("unexpected section number")
        }
        
        return section.numberOfObjects
    }
    ///Allows to have swipe and actions on one line of the table
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //teacher concerned (line on the table)
        let teacher = self.teachersFetched.object(at: indexPath)
        //action on validate button
        let validate  = UITableViewRowAction(style: .normal, title: "Validate") { (rowAction, indexPath) in
            self.teachTable.beginUpdates()
            let okV = Teacher.updateTeacher(teacher: teacher,accountValidate: true)
            //inform the user that it works or not
            guard (okV == nil) else {
                DialogBoxHelper.alert(view: self, withTitle: "Validation Failed", andMessage: "The teacher account is not active")
                return
            }
            DialogBoxHelper.alert(view: self, withTitle: "Validation Succeed", andMessage: "The teacher account has been activated")
            self.teachTable.endUpdates()
            //refresh the table
            self.teachTable.reloadData()
        }
        //action on desactivate button
        let desactive  = UITableViewRowAction(style: .normal, title: "Desactive") { (rowAction, indexPath) in
            self.teachTable.beginUpdates()
            let okD = Teacher.updateTeacher(teacher:teacher,accountValidate:false)
            //inform the user that it works or not
            guard (okD == nil) else {
                DialogBoxHelper.alert(view: self, withTitle: "Desactivation Failed", andMessage: "The teacher account is still active")
                return
            }
            DialogBoxHelper.alert(view: self, withTitle: "Desactivation Succeed", andMessage: "The teacher account has been desactivated")
            self.teachTable.endUpdates()
            //refresh the table
            self.teachTable.reloadData()
        }
        let setManager  = UITableViewRowAction(style: .normal, title: "Make Manager") { (rowAction, indexPath) in
            self.teachTable.beginUpdates()
            let okD = Teacher.updateTeacher(teacher:teacher,specialtyManager:true)
            //inform the user that it works or not
            guard (okD == nil) else {
                DialogBoxHelper.alert(view: self, withTitle: "Manager change Failed", andMessage: "The teacher account hasn't been set to manager")
                return
            }
            DialogBoxHelper.alert(view: self, withTitle: "Change succesful", andMessage: "\(teacher.lastname) is now a specialty manager")
            self.teachTable.endUpdates()
            //refresh the table
            self.teachTable.reloadData()
        }
        let unsetManager  = UITableViewRowAction(style: .normal, title: "Not a Manager") { (rowAction, indexPath) in
            self.teachTable.beginUpdates()
            let okD = Teacher.updateTeacher(teacher:teacher,specialtyManager:false)
            //inform the user that it works or not
            guard (okD == nil) else {
                DialogBoxHelper.alert(view: self, withTitle: "Manager change Failed", andMessage: "The teacher account is still set to manager")
                return
            }
            DialogBoxHelper.alert(view: self, withTitle: "Change succesful", andMessage: "\(teacher.lastname) is not a specialty manager anymore")
            self.teachTable.endUpdates()
            //refresh the table
            self.teachTable.reloadData()
        }
        //action on delete button
        let deleteAction  = UITableViewRowAction(style: .default, title: "Delete") { (rowAction, indexPath) in
            
            self.teachTable.beginUpdates()
            //TODO delete account in usersSet
            let okDel = Teacher.deleteTeacher(teacher:teacher)
            //inform the user that it works or not
            guard (okDel == nil) else {
                DialogBoxHelper.alert(view: self, withTitle: "Deletion Failed", andMessage: "The teacher account still exists")
                return
            }
            DialogBoxHelper.alert(view: self, withTitle: "Deletion Succeed", andMessage: "The teacher account has been deleted")
            self.teachTable.endUpdates()
            //refresh the table
            self.teachTable.reloadData()
        }
        desactive.backgroundColor = UIColor.orange
        validate.backgroundColor = UIColor.red
        deleteAction.backgroundColor = UIColor.green
        setManager.backgroundColor = UIColor.cyan
        unsetManager.backgroundColor = UIColor.purple
        if teacher.accountValidate{
            if teacher.specialtyManager{
                return [deleteAction,desactive,unsetManager]
            }else{
                return [deleteAction,desactive,setManager]
            }
            
        }else{
            return [deleteAction,validate]
        }
    }
    
    //MARK - NSFecthResultController
    
    //MARK: - Controller methods
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.teachTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.teachTable.endUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?){
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath{
                self.teachTable.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath{
                self.teachTable.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
    }

    
    /// update the request and so the table of teachers
    ///
    /// - Parameter predicate: predicate of the request
    func updateTeachers(predicate : [NSPredicate]){
        if predicate == []{
        }else{
            var predicates : [NSPredicate] = []
            for p in predicate{
                predicates.append(p)
            }
            self.teachersFetched = NSFetchResultUpdater.updateTeacherPredicate(predicates: predicates)
        }
        do{
            try self.teachersFetched.performFetch()
            self.teachTable.reloadData()
        }catch let error as NSError{
            DialogBoxHelper.alert(view: self, error: error)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
}
