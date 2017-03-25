//
//  NSFetchResultUpdater.swift
//  Zboobee
//
//  Created by Laure MARCHAL on 23/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import CoreData



/// Utility class providing methods to manage message objects
class NSFetchResultUpdater {
    
    //MARK Updater for Messages
    /// Returns a NSFetchedResultsController according to different predicates
    ///
    /// - Parameter withPredicates: an array of predicates to apply
    /// - Returns: a NSFetchedResultController object containing all the posts concerned by the predicates
    class func updateMessagePredicate(predicates: [NSPredicate]) -> NSFetchedResultsController<Message>{
        
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Message.date), ascending: false)]
        let fetchResultController : NSFetchedResultsController<Message> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }
    
    class func updateMessagePredicate(predicate: NSPredicate) -> NSFetchedResultsController<Message>{
        
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Message.date), ascending: false)]
        let fetchResultController : NSFetchedResultsController<Message> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }
    
    //MARK updater for Events
    class func updateEventPredicate(predicates: [NSPredicate]) -> NSFetchedResultsController<Event>{
        
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Event.date), ascending: false)]
        let fetchResultController : NSFetchedResultsController<Event> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }
    
    class func updateEventPredicate(predicate: NSPredicate) -> NSFetchedResultsController<Event>{
        
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Event.date), ascending: false)]
        let fetchResultController : NSFetchedResultsController<Event> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }
    
    //MARK updater for Students
    class func updateStudentPredicate(predicates: [NSPredicate]) -> NSFetchedResultsController<Student>{
        
        let request: NSFetchRequest<Student> = Student.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Student.lastname), ascending: true)]
        let fetchResultController : NSFetchedResultsController<Student> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }
    
    class func updateStudentPredicate(predicate: NSPredicate) -> NSFetchedResultsController<Student>{
        
        let request: NSFetchRequest<Student> = Student.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Student.lastname), ascending: true)]
        let fetchResultController : NSFetchedResultsController<Student> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }
}
