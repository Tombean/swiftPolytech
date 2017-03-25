//
//  MessageExtension.swift
//  Zboobee
//
//  Created by Laure Marchal on 13/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation

///Class that manages object message in the coreData
extension Message{
    
    
    /// create a Message
    ///
    /// - Parameters:
    ///   - title: titre
    ///   - text: content
    ///   - date: date emission
    ///   - lengthMax: max length of characters
    ///   - originator: user who posted it
    ///   - groups: adressed to them
    /// - Returns: a message
    static func createMessage(title: String,text: String, date: Date, lengthMax: Int16, originator : User, groups : NSSet)->Message{
        
        let context = CoreDataManager.context
        let newMessage : Message = Message(context: context)
        newMessage.title = title
        newMessage.content = text
        newMessage.date = date as NSDate?
        newMessage.maxLength = lengthMax
        newMessage.isPosted = originator
        newMessage.groups = groups
        
        return newMessage
    }

    
}
