//
//  OfficeExtension.swift
//  Zboobee
//
//  Created by Tom SOMERVILLE-ROBERTS on 08/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation

extension Office{
    
    /// creates a new office
    ///
    /// - Parameters:
    ///   - firstname: firstname of the user
    ///   - lastname: lastname
    ///   - email: email address of the user
    ///   - password: password of the user
    ///   - promotions: promotions that it manages
    /// - Returns: the office or nil if is not created
    static func createOffice(firstname: String,lastname: String, email: String, password: String, promotions: NSSet?)->Office?{
        
        let context = CoreDataManager.context
        let newOffice : Office = Office(context: context)
        newOffice.firstname = firstname
        newOffice.lastname = lastname
        newOffice.mailUniv = email
        // ATTENTION CRYPTER LE PASSWORD PLUS TARD
        newOffice.password = password
        newOffice.promotions = promotions
        var  groups : [Group]? = nil
        if promotions == nil{
            groups = [GroupsSet.findGroupByName(name: "Teacher")!,
                      GroupsSet.findGroupByName(name: "Office")!]
        }
        else{
            groups = [GroupsSet.findGroupByName(name: "Teacher")!,GroupsSet.findGroupByName(name: "Office")!,GroupsSet.findGroupByName(name: "IG5 - Teacher")!,GroupsSet.findGroupByName(name: "IG4 - Teacher")!,GroupsSet.findGroupByName(name: "IG3 - Teacher")!,GroupsSet.findGroupByName(name: "IG5")!,GroupsSet.findGroupByName(name: "IG4")!,GroupsSet.findGroupByName(name: "IG3")!]
        }
        let officeGroups : NSSet? = groups as! NSSet
        newOffice.groups = officeGroups
        return newOffice
    }
}
