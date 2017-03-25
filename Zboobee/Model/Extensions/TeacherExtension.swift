//
//  TeacherExtension.swift
//  Zboobee
//
//  Created by Tom SOMERVILLE-ROBERTS on 08/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import CoreData

extension Teacher{
        
        /// creates a new teacher
        ///
        /// - Parameters:
        ///   - firstname: firstname of the user
        ///   - lastname: lastname
        ///   - email: email address of the user
        ///   - password: password of the user
        ///   - accountValidate: false by befault and set to true by office
    ///   - promotions: promotions that he teaches
    /// - Returns: the teacher or nil if is not created
    static func createTeacher(firstname: String,lastname: String, email: String, password: String,accountValidate: Bool, promotions: NSSet?)->Teacher{
            
        let context = CoreDataManager.context
        let newTeacher : Teacher = Teacher(context: context)
        newTeacher.firstname = firstname
        newTeacher.lastname = lastname
        newTeacher.mailUniv = email
        // ATTENTION CRYPTER LE PASSWORD PLUS TARD
        newTeacher.password = password
        newTeacher.accountValidate = accountValidate
        newTeacher.promotions = promotions
        var  groups : NSSet? = nil
        if promotions == nil{
            groups = [GroupsSet.findGroupByName(name: "Teacher")!,
                      GroupsSet.findGroupByName(name: "Office")!]
        }
//        else{
//            for p in promotions! {
//                let pr : Promotion = p as! Promotion
//                let i : Int = Int(pr.graduationYear)
//                groups = [GroupsSet.findGroupByName(name: "Teacher")!,GroupsSet.findGroupByName(name: "Office")!]
//                switch(i){
//                    case 2017:
//                        groups?.append(GroupsSet.findGroupByName(name: "IG5 - Teacher")!)
//                    case 2018:
//                        groups?.append(GroupsSet.findGroupByName(name: "IG4 - Teacher")!)
//                    case 2019:
//                        groups?.append(GroupsSet.findGroupByName(name: "IG3 - Teacher")!)
//                    default: break
//                    
//                }
//            }
//        }
//        let teacherGroups : NSSet? = (groups as! NSSet)
        newTeacher.groups = groups
        return newTeacher
        }
}
