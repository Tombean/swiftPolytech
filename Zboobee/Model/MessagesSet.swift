//
//  MessagesSet.swift
//  Zboobee
//
//  Created by Laure Marchal on 13/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import CoreData

///Class that manages a collection of messages in the core
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
    
    /// find all the messages
    ///
    /// - Returns: an array of messages
    static func findAllMessages()->[Message]{
        var messages : [Message] = []
        let context = CoreDataManager.context
        let requestMessage: NSFetchRequest<Message> = Message.fetchRequest()
        do{
            try messages = context.fetch(requestMessage)
        }catch{
            return []
        }
        return messages
    }
    
    /// find all the messages to one group
    ///
    /// - Parameter groupName: name of the group
    /// - Returns: an array of messages
    static func findAllMessagesForGroup(groupName : String)->[Message]?{
        var messages : [Message] = []
        let context = CoreDataManager.context
        let requestMessage: NSFetchRequest<Message> = Message.fetchRequest()
        requestMessage.predicate = NSPredicate(format: "ANY groups.name == %@", groupName)
        do{
            try messages = context.fetch(requestMessage)
        }catch{
            return nil
        }
        return messages
    }
    
}
