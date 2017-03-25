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

class SettingsStudentsController : UIViewController, UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate{
    
    
    @IBOutlet weak var titleStudents: UILabel!
    @IBOutlet weak var studTable: UITableView!

    
    
    //Students
    fileprivate lazy var studentsFetched : NSFetchedResultsController<Student> = {
        let request :  NSFetchRequest<Student> =  Student.fetchRequest()
        request.predicate = NSPredicate(format: "accountValidate == false")
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Student.lastname),ascending:true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()
    
    
    @IBAction func desactivateButton(_ sender: Any) {
    }
    @IBAction func activateButton(_ sender: Any) {
    }
    var students: [Student] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateStudents(predicate: [])
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //self.updateMessages()
        let cell = self.studTable.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath) as! studentTableViewCell
        let student = self.studentsFetched.object(at: indexPath)
        cell.lastname.text = student.lastname
        cell.firstname.text = student.firstname
        cell.promotion.text = String(describing: student.promotion?.graduationYear)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let student = self.studentsFetched.object(at: indexPath)
        if student.accountValidate == false{
            cell.contentView.backgroundColor = UIColor.red
        }else{
            cell.contentView.backgroundColor = UIColor.green
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        guard let section = self.studentsFetched.sections?[section] else {
            fatalError("unexpected section number")
        }
        
        return section.numberOfObjects
    }
    
    
    //MARK NSFecthResultController
    
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
    
    //Students
    func updateStudents(predicate : [NSPredicate]){
        if predicate == []{
            self.studentsFetched = NSFetchResultUpdater.updateStudentPredicate(predicate: NSPredicate(format: "accountValidate == false"))
        }else{
            var predicates : [NSPredicate] = []
            for p in predicate{
                predicates.append(p)
            }
            predicates.append(NSPredicate(format: "accountValidate == false"))
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
