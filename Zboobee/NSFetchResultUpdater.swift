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
    
    /// Returns a NSFetchedResultsController according to different predicates
    ///
    /// - Parameter withPredicates: an array of predicates to apply
    /// - Returns: a NSFetchedResultController object containing all the posts concerned by the predicates
    class func updatePredicate(predicates: [NSPredicate]) -> NSFetchedResultsController<Message>{
        
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Message.date), ascending: false)]
        let fetchResultController : NSFetchedResultsController<Message> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }
    
    class func updatePredicate(predicate: NSPredicate) -> NSFetchedResultsController<Message>{
        
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Message.date), ascending: false)]
        let fetchResultController : NSFetchedResultsController<Message> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }
}
