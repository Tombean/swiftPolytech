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

class SettingsController : UIViewController, UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate{
    
    //Variable user get from the login
    var userloged : User?
    
    @IBOutlet weak var titleStudents: UILabel!
    @IBOutlet weak var titleTeachers: UILabel!
    @IBOutlet weak var studTable: UITableView!
    @IBOutlet weak var teachTable: UITableView!
    
    
    //Students
    fileprivate lazy var studentsFetched : NSFetchedResultsController<Student> = {
        let request :  NSFetchRequest<Student> =  Student.fetchRequest()
        request.predicate = NSPredicate(format: "accountValidate == %@", 0)
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Student.lastname),ascending:true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()
    
    //Teachers
    fileprivate lazy var teachersFetched : NSFetchedResultsController<Teacher> = {
        let request :  NSFetchRequest<Teacher> =  Teacher.fetchRequest()
        request.predicate = NSPredicate(format: "accountValidate == %@", 0)
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Teacher.lastname),ascending:true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()
    
    @IBAction func desactivateButton(_ sender: Any) {
    }
    @IBAction func activateButton(_ sender: Any) {
    }
    var students: [Student] = []
    var teachers: [Teacher] = []
    
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
    
    override func viewDidLoad() {
        self.userloged = UserSession.instance.user
        guard self.userloged != nil else{
            fatalError("No user selected!!!")
        }
        super.viewDidLoad()
        guard ((self.userloged is Teacher) || (self.userloged is Office)) else{
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            DialogBoxHelper.alert(view: self, withTitle: "Unauthorized feature", andMessage: "User settings are only for techers and office", action: cancelAction )
            return
        }
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
        self.teachTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.studTable.endUpdates()
        self.teachTable.endUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?){
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath{
                self.studTable.insertRows(at: [newIndexPath], with: .automatic)
                self.teachTable.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath{
                self.studTable.deleteRows(at: [indexPath], with: .automatic)
                self.teachTable.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
    }
    
    //Students
    func updateStudents(predicate : [NSPredicate]){
        if predicate == []{
            self.studentsFetched = NSFetchResultUpdater.updateStudentPredicate(predicate: NSPredicate(format: "accountValidate == %@", 0))
        }else{
            var predicates : [NSPredicate] = []
            for p in predicate{
                predicates.append(p)
            }
            predicates.append(NSPredicate(format: "accountValidate == %@", 0))
            self.studentsFetched = NSFetchResultUpdater.updateStudentPredicate(predicates: predicates)
        }
        do{
            try self.studentsFetched.performFetch()
            self.studTable.reloadData()
        }catch let error as NSError{
            DialogBoxHelper.alert(view: self, error: error)
        }
    }
    
    //Teachers
    func updateTeachers(predicate : [NSPredicate]){
        if predicate == []{
            self.teachersFetched = NSFetchResultUpdater.updateTeacherPredicate(predicate: NSPredicate(format: "accountValidate == %@", 0))
        }else{
            var predicates : [NSPredicate] = []
            for p in predicate{
                predicates.append(p)
            }
            predicates.append(NSPredicate(format: "accountValidate == %@", 0))
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
