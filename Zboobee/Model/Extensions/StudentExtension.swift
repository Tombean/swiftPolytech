//
//  StudentExtension.swift
//  Zboobee
//
//  Created by Tom SOMERVILLE-ROBERTS on 08/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import CoreData

///extension of the object Student in the core
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
        // in function of the promotion assigns the groups
        var  groups : NSSet
        if promotion == nil{
            groups = [GroupsSet.findGroupByName(name: "Students")!]
        }
        else{
            let promo : Int = Int((promotion?.graduationYear)!)
            switch(promo){
            case 2017:
                groups = [GroupsSet.findGroupByName(name: "Students")!,
                          GroupsSet.findGroupByName(name: "IG5")!,
                          GroupsSet.findGroupByName(name: "IG5 - Teacher")!,
                          GroupsSet.findGroupByName(name: "Office")!]
            case 2018:
                groups = [GroupsSet.findGroupByName(name: "Students")!,
                          GroupsSet.findGroupByName(name: "IG4")!,
                          GroupsSet.findGroupByName(name: "IG4 - Teacher")!,
                          GroupsSet.findGroupByName(name: "Office")!]
            case 2019:
                groups = [GroupsSet.findGroupByName(name: "Students")!,
                          GroupsSet.findGroupByName(name: "IG3")!,
                          GroupsSet.findGroupByName(name: "IG3 - Teacher")!,
                          GroupsSet.findGroupByName(name: "Office")!]
            default:
                groups = [GroupsSet.findGroupByName(name: "Students")!,
                          GroupsSet.findGroupByName(name: "Office")!]
            }
        }
        newStudent.groups = groups
        return newStudent
    }
    
    /// update the validation of the student's account
    ///
    /// - Parameters:
    ///   - student: student
    ///   - accountValidate: the boolean for the validation of the account
    /// - Returns: an error or nothing if it works
    static func updateStudent(student: Student,accountValidate: Bool)->NSError?{
        let context = CoreDataManager.context
        student.accountValidate = accountValidate
        if let error = CoreDataManager.save() {
            context.rollback()
            return error
        }
        else {
            print("User updated successfully")
            return nil
        }
    }
    
    /// delete a student's account
    ///
    /// - Parameters:
    ///   - student: student
    /// - Returns: an error or nothing if it works
    static func deleteStudent(student:Student)->NSError?{
        let context = CoreDataManager.context
        //TODO
        if let error = CoreDataManager.save() {
            context.rollback()
            return error
        }
        else {
            print("User deleted successfully")
            return nil
        }
    }
}
