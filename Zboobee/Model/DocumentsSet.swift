//
//  DocumentsSet.swift
//  Zboobee
//
//  Created by Laure MARCHAL on 24/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import CoreData

class DocumentsSet{
    
    /// Add an Document to the collection
    ///
    /// - Parameter documentToAdd: Document created already
    /// - Returns: return true if it is added
    static func addDocument(documentToAdd : Document)->Bool{
        
        let context = documentToAdd.managedObjectContext
        do {
            try context?.save()
        } catch {
            return false
        }
        return true
    }
}
