//
//  SettingsController.swift
//  Zboobee
//
//  Created by Laure MARCHAL on 22/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/// Class that controls the settings account of students view
class SettingsStudentsController : UIViewController, UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate{
    
    ///titleStudents
    @IBOutlet weak var titleStudents: UILabel!
    ///studTable
    @IBOutlet weak var studTable: UITableView!

    
    /// Stop the action and return to the old view
    ///
    /// - Parameter sender: no need to know
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    ///Closure to get the students we want to see and sort them by lastname
    fileprivate lazy var studentsFetched : NSFetchedResultsController<Student> = {
        let request :  NSFetchRequest<Student> =  Student.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Student.lastname),ascending:true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()
    //students in the table view
    var students: [Student] = []

    ///Launch the view
    override func viewDidLoad() {
        super.viewDidLoad()
        //update the request and the table
        self.updateStudents(predicate: [])
    }
    
    //MARK: - Delegates and data sources
    
    //MARK : Table View
    
    //MARK: Data Sources
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //self.updateStudents()
        let cell = self.studTable.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath) as! studentTableViewCell
        let student = self.studentsFetched.object(at: indexPath)
        cell.lastname.text = student.lastname
        cell.firstname.text = student.firstname
        let promo : String = "\((student.promotion?.specialty)!) \(String(describing: (student.promotion?.graduationYear)!))"
        cell.promotion.text = promo
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let student = self.studentsFetched.object(at: indexPath)
        if student.accountValidate == false{
            cell.contentView.backgroundColor = UIColor.orange
        }else{
            cell.contentView.backgroundColor = UIColor.magenta
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    ///Allows to have swipe and actions on one line of the table
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //student concerned (line on the table)
        let student = self.studentsFetched.object(at: indexPath)
        //action on validate button
        let validate  = UITableViewRowAction(style: .normal, title: "Validate") { (rowAction, indexPath) in
            self.studTable.beginUpdates()
            let okV = Student.updateStudent(student:student,accountValidate:true)
            //inform the user that it works or not
            guard (okV == nil) else {
                DialogBoxHelper.alert(view: self, withTitle: "Validation Failed", andMessage: "The student account is not active")
                return
            }
            DialogBoxHelper.alert(view: self, withTitle: "Validation Succeed", andMessage: "The student account is active")
            self.studTable.endUpdates()
            //refresh the table
            self.studTable.reloadData()
        }
        //action on desactivate button
        let desactive  = UITableViewRowAction(style: .normal, title: "Desactive") { (rowAction, indexPath) in
            self.studTable.beginUpdates()
            let okD = Student.updateStudent(student:student,accountValidate:false)
            //inform the user that it works or not
            guard (okD == nil) else {
                DialogBoxHelper.alert(view: self, withTitle: "Desactivation Failed", andMessage: "The student account is still active")
                return
            }
            DialogBoxHelper.alert(view: self, withTitle: "Desactivation Succeed", andMessage: "The student account is desactivated")
            self.studTable.endUpdates()
            //refresh the table
            self.studTable.reloadData()
        }
        //action on delete button
        let deleteAction  = UITableViewRowAction(style: .default, title: "Delete") { (rowAction, indexPath) in
            self.studTable.beginUpdates()
            //TODO delete account in usersSet
            let okDel = Student.deleteStudent(student:student)
            //inform the user that it works or not
            guard (okDel == nil) else {
                DialogBoxHelper.alert(view: self, withTitle: "Deletion Failed", andMessage: "The student account still exists")
                return
            }
            DialogBoxHelper.alert(view: self, withTitle: "Deletion Succeed", andMessage: "The student account has been deleted")
            self.studTable.endUpdates()
            //refresh the table
            self.studTable.reloadData()
        }
        //set the color
        desactive.backgroundColor = UIColor.orange
        validate.backgroundColor = UIColor.green
        deleteAction.backgroundColor = UIColor.red
        //in functionof the account give 2 differents possibilities
        if student.accountValidate{
            return [deleteAction,desactive]
        }else{
            return [deleteAction,validate]
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        guard let section = self.studentsFetched.sections?[section] else {
            fatalError("unexpected section number")
        }
        
        return section.numberOfObjects
    }
    
    
    //MARK - NSFecthResultController
    
    //MARK: - Controller methods
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.studTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.studTable.endUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?){
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath{
                self.studTable.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath{
                self.studTable.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
    }
    
    /// update the request and so the table of students
    ///
    /// - Parameter predicate: predicate of the request
    func updateStudents(predicate : [NSPredicate]){
        if predicate == []{
        }else{
            var predicates : [NSPredicate] = []
            for p in predicate{
                predicates.append(p)
            }
            self.studentsFetched = NSFetchResultUpdater.updateStudentPredicate(predicates: predicates)
        }
        do{
            try self.studentsFetched.performFetch()
            self.studTable.reloadData()
        }catch let error as NSError{
            DialogBoxHelper.alert(view: self, error: error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
}
