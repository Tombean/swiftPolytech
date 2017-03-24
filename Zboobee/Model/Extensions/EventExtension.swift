//
//  EventExtension.swift
//  Zboobee
//
//  Created by polytech on 24/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation

extension Event{
    
    
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
    static func createEvent(title:String,description:String,duration:String,location:String,date: Date,originator:User,group: Group)->Event{
        
        let context = CoreDataManager.context
        let newEvent : Event = Event(context: context)
        newEvent.title = title
        newEvent.desc = description
        newEvent.duration = duration
        newEvent.place = location
        newEvent.isCreated = originator
        newEvent.date = date as NSDate?
        newEvent.group = group
        
        return newEvent
    }
    
    
}
