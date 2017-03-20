//
//  GroupsSet.swift
//  Zboobee
//
//  Created by Laure Marchal on 16/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import CoreData

class GroupsSet{
    
    static func findGroupByName(name: String)->Group?{
        var groups : [Group] = []
        let context = CoreDataManager.context
        let requestGroup: NSFetchRequest<Group> = Group.fetchRequest()
        requestGroup.predicate = NSPredicate(format: "name == %@", name)
        do{
            print("coucou")
            print(name)
            try groups = context.fetch(requestGroup)
            print("ok")
        }catch{
            print("pas marché")
            return nil
        }
        if groups.count > 0{
            print("ok group",groups[0])
            return groups[0]
        }
        else{
            print("pas de groupe")
            return nil
        }
    }
    
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
