//
//  EventsSet.swift
//  Zboobee
//
//  Created by polytech on 24/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import CoreData

/// Class that manages a collection of events in the core
class EventsSet{
    
    /// Add an event to the collection
    ///
    /// - Parameter eventToAdd: Event created already
    /// - Returns: return true if it is added
    static func addEvent(eventToAdd : Event)->Bool{
        
        let context = eventToAdd.managedObjectContext
        do {
            try context?.save()
        } catch {
            return false
        }
        return true
    }
}

