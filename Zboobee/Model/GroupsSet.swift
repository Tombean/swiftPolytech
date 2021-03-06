//
//  GroupsSet.swift
//  Zboobee
//
//  Created by Laure Marchal on 16/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import CoreData

//Class that manages a collection of groups in the core
class GroupsSet{
    
    /// fing one group
    ///
    /// - Parameter name: name of the group
    /// - Returns: group
    static func findGroupByName(name: String)->Group?{
        var groups : [Group] = []
        let context = CoreDataManager.context
        let requestGroup: NSFetchRequest<Group> = Group.fetchRequest()
        requestGroup.predicate = NSPredicate(format: "name == %@", name)
        do{
            try groups = context.fetch(requestGroup)

        }catch{
            return nil
        }
        return groups[0]

    }
    
    /// find all groups
    ///
    /// - Returns: an array of groups
    static func findAllGroups()->[Group]?{
        var groups : [Group] = []
        let context = CoreDataManager.context
        let requestGroup: NSFetchRequest<Group> = Group.fetchRequest()
        do{
            try groups = context.fetch(requestGroup)
        }catch{
            return nil
        }
        if groups.count > 0{
            return groups
        }
        else{
            return nil
        }
    }
}
