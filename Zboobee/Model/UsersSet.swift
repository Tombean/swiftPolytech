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
        print("email=\(email)")
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
    
    /// add a user in the database
    ///
    /// - Parameters:
    ///   - firstname: firstname of the user
    ///   - lastname: lastname
    ///   - email: email address of the user
    ///   - password: password of the user
    ///   - type: type of the user (Teacher, Manager, Secretariat,Student)
    /// - Returns: true if the user is added, false if not
    static func addUser(firstname: String,lastname: String, email: String, password: String, type : Int)->Bool{
        let context = CoreDataManager.context
        guard type != nil else{
            return false
        }
        var newUser: User
        if type is Promotion{
            newUser = Student(context: context)
            newUser.promotion = type
        }
        if type is Teacher{
             newUser = Teacher(context: context)
        }
        
        
        newUser.firstname = firstname
        newUser.lastname = lastname
        newUser.mailUniv = email
        
        //newUser.accountValidate = false
        // ATTENTION CRYPTER LE PASSWORD PLUS TARD
        newUser.password = password
        //newUser.type = type
        do {
            try context.save()
        } catch {
            return false
        }

        
        return true
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
}
