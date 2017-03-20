//
//  MessagesSet.swift
//  Zboobee
//
//  Created by Laure Marchal on 13/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import CoreData

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
    
    static func findAllMessages()->[Message]?{
        var messages : [Message] = []
        let context = CoreDataManager.context
        let requestMessage: NSFetchRequest<Message> = Message.fetchRequest()
        do{
            try messages = context.fetch(requestMessage)
        }catch{
            return nil
        }
        if messages.count > 0{
            return messages
        }
        else{
            return nil
        }
    }
    
}
