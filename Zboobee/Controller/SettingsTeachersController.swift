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

class SettingsTeachersController : UIViewController, UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate{
    
    
    @IBOutlet weak var titleteachers: UILabel!
    @IBOutlet weak var teachTable: UITableView!
    
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Teachers
    fileprivate lazy var teachersFetched : NSFetchedResultsController<Teacher> = {
        let request :  NSFetchRequest<Teacher> =  Teacher.fetchRequest()
        //request.predicate = NSPredicate(format: "accountValidate == false")
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Teacher.lastname),ascending:true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateTeachers(predicate: [])
    
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources tableview
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

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let teacher = self.teachersFetched.object(at: indexPath)
        let validate  = UITableViewRowAction(style: .normal, title: "Validate") { (rowAction, indexPath) in
            self.teachTable.beginUpdates()
            //TODO update account validate in usersSet
            Teacher.updateTeacher(teacher: teacher,accountValidate: true)
            self.teachTable.endUpdates()
            self.teachTable.reloadData()
        }
        let desactive  = UITableViewRowAction(style: .normal, title: "Desactive") { (rowAction, indexPath) in
            self.teachTable.beginUpdates()
            //TODO update account validate in usersSet
            Teacher.updateTeacher(teacher:teacher,accountValidate:false)
            self.teachTable.endUpdates()
            self.teachTable.reloadData()
        }
        let deleteAction  = UITableViewRowAction(style: .default, title: "Delete") { (rowAction, indexPath) in
            
            self.teachTable.beginUpdates()
            //TODO delete account in usersSet
            Teacher.deleteTeacher(teacher:teacher)
            self.teachTable.endUpdates()
            self.teachTable.reloadData()
        }
        desactive.backgroundColor = UIColor.orange
        validate.backgroundColor = UIColor.red
        deleteAction.backgroundColor = UIColor.green
        if teacher.accountValidate{
            return [deleteAction,desactive]
        }else{
            return [deleteAction,validate]
        }
    }
    
    //MARK NSFecthResultController
    
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

    
    //Teachers
    func updateTeachers(predicate : [NSPredicate]){
        if predicate == []{
            //self.teachersFetched = NSFetchResultUpdater.updateTeacherPredicate(predicate: NSPredicate(format: "accountValidate == false"))
        }else{
            var predicates : [NSPredicate] = []
            for p in predicate{
                predicates.append(p)
            }
            //predicates.append(NSPredicate(format: "accountValidate == false"))
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
