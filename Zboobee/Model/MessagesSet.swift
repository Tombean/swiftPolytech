//
//  MessagesSet.swift
//  Zboobee
//
//  Created by Laure Marchal on 13/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation

class MessagesSet{
    
    /// Add a message to the collection
    ///
    /// - Parameter messageToAdd: Message created already
    /// - Returns: return true if it is added
    static func addMessage(messageToAdd : Message)->Bool{
        
        let context = messageToAdd.managedObjectContext
        do {
            try context?.save()
        } catch {
            return false
        }
        return true
    }
    
}
