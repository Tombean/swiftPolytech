//
//  UsersSet.swift
//  Zboobee
//
//  Created by Tom SOMERVILLE-ROBERTS on 02/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import CoreData

class UsersSet{
    
    // MARK: - User management -
   
    
    /// Retrieve the user that has the email address used as parameter.
    ///
    /// - Parameter email: email address of the user
    /// - Returns: Returns the user who has the email given as a parameter, nothing if no user was found
    static func findUser(email: String)->User?{
        var users : [User] = []
        let context = CoreDataManager.context
        let requestUser: NSFetchRequest<User> = User.fetchRequest()
        requestUser.predicate = NSPredicate(format: "mailUniv == %@", email)
        do{
            try users = context.fetch(requestUser)
        }catch{
            return nil
        }
        if users.count > 0{
            return users[0]
        }
        else{
            return nil
        }
    }
    
    /// check if a user can login based on email and password
    ///
    /// - Parameter email: email address of the user
    /// - Parameter password: password of the user
    /// - Returns: Returns the user who has the email given as a parameter, nothing if no user was found
    static func canLogin(email: String, password: String)->Bool{
        let user : User? = self.findUser(email: email)
        let canlogin: Bool = (user?.password == password) as Bool
        print(canlogin)
        return canlogin
    }
 
    
    /// add a student to the collection
    ///
    /// - Parameter studentToAdd: object student
    /// - Returns: true if the student is added
    static func addStudent(studentToAdd : Student)->Bool{
        let context = studentToAdd.managedObjectContext
        do {
            try context?.save()
        } catch {
            return false
        }
        return true
    }
    
    /// add a teacher to the collection
    ///
    /// - Parameter teacherToAdd: object teacher
    /// - Returns: true if the teacher is added
    static func addTeacher(teacherToAdd : Teacher)->Bool{
        let context = teacherToAdd.managedObjectContext
        do {
            try context?.save()
        } catch {
            return false
        }
        return true
    }
    
    /// add an office to the collection
    ///
    /// - Parameter officeToAdd: object office
    /// - Returns: true if the office is added
    static func addOffice(officeToAdd : Office?)->Bool{
        //let context = CoreDataManager.context
        guard officeToAdd != nil else{
            return false
        }
        /*
        var user : Office =  Office(context: context)
        user  =  officeToAdd!
        */
        if CoreDataManager.save() == nil{ // no error
            return true
        }
        else{
            //CoreDataManager.context.rollback()
            return false
        }
    }

    
    // MARK: - Promo management -
    static func findAllPromotion()->[Promotion]?{
        var promo : [Promotion] = []
        let requestPromo: NSFetchRequest<Promotion> = Promotion.fetchRequest()
        let context = CoreDataManager.context
        do{
            try promo = context.fetch(requestPromo)
        }catch{
            return nil
        }
        if promo.count > 0{
            return promo
        }
        else{
            return nil
        }
        
    }
    
    static func findOnePromotion(specialty : String, year : Int)->Promotion?{
        var promo : [Promotion] = []
        let requestPromo: NSFetchRequest<Promotion> = Promotion.fetchRequest()
        requestPromo.predicate = NSPredicate(format: "specialty == %@ and graduationYear == %A", specialty, year)
        let context = CoreDataManager.context
        do{
            try promo = context.fetch(requestPromo)
        }catch{
            return nil
        }
        if promo.count > 0{
            return promo[0]
        }
        else{
            return nil
        }
    }
    
    //MARK : Office management
    
    static func findOffice(email:String)->Office?{
        var office : [Office] = []
        let requestOffice: NSFetchRequest<Office> = Office.fetchRequest()
        requestOffice.predicate = NSPredicate(format: "mailUniv == %@", email)
        let context = CoreDataManager.context
        do{
            try office = context.fetch(requestOffice)
        }catch{
            return nil
        }
        if office.count > 0{
            return office[0]
        }
        else{
            return nil
        }
    }
}
