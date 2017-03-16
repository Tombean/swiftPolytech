//
//  StudentExtension.swift
//  Zboobee
//
//  Created by Tom SOMERVILLE-ROBERTS on 08/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import CoreData

extension Student{
    
    /// creates a new student
    ///
    /// - Parameters:
    ///   - firstname: firstname of the user
    ///   - lastname: lastname
    ///   - email: email address of the user
    ///   - password: password of the user
    ///   - accountValidate: false by befault and set to true by office
    /// - Returns: the student or nil if is not created
    static func createStudent(firstname: String,lastname: String, email: String, password: String, accountValidate: Bool, promotion: Promotion?)->Student{
        
        let context = CoreDataManager.context
        let newStudent : Student = Student(context: context)
        newStudent.firstname = firstname
        newStudent.lastname = lastname
        newStudent.mailUniv = email
        //TODO ATTENTION CRYPTER LE PASSWORD PLUS TARD
        newStudent.password = password
        newStudent.accountValidate = accountValidate
        newStudent.promotion = promotion
        var  groups : NSSet
        if promotion == nil{
            groups = [GroupsSet.findGroupByName(name: "Students")]
        }
        else{
            switch(promotion?.graduationYear as Int){
            case 2017:
                groups = [GroupsSet.findGroupByName(name: "Students"),
                          GroupsSet.findGroupByName(name: "IG5"),
                          GroupsSet.findGroupByName(name: "IG5 - Teacher"),
                          GroupsSet.findGroupByName(name: "Office")]
            case 2018:
                groups = [GroupsSet.findGroupByName(name: "Students"),
                          GroupsSet.findGroupByName(name: "IG4"),
                          GroupsSet.findGroupByName(name: "IG4 - Teacher"),
                          GroupsSet.findGroupByName(name: "Office")]
            case 2019:
                groups = [GroupsSet.findGroupByName(name: "Students"),
                          GroupsSet.findGroupByName(name: "IG3"),
                          GroupsSet.findGroupByName(name: "IG3 - Teacher"),
                          GroupsSet.findGroupByName(name: "Office")]
            default:
                groups = [GroupsSet.findGroupByName(name: "Students"),
                          GroupsSet.findGroupByName(name: "Office")]
            }
        }
        newStudent.groups = groups
        return newStudent
    }
}
