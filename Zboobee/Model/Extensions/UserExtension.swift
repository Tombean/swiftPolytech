//
//  UserExtension.swift
//  Zboobee
//
//  Created by Tom SOMERVILLE-ROBERTS on 02/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation

///extension of the object User in the core
extension User{
    
    /// creates a new user
    ///
    /// - Parameters:
    ///   - firstname: firstname of the user
    ///   - lastname: lastname
    ///   - email: email address of the user
    ///   - password: password of the user
    /// - Returns: true if the user is added, false if not
    static func createUser(firstname: String,lastname: String, email: String, password: String)->User?{
        
        let newUser : User? =  nil
        newUser?.firstname = firstname
        newUser?.lastname = lastname
        newUser?.mailUniv = email
        // ATTENTION CRYPTER LE PASSWORD PLUS TARD
        newUser?.password = password
        
        return newUser
    }
    
    /// update the password of a user
    ///
    /// - Parameters:
    ///   - user: user
    ///   - newpassword: the new password
    /// - Returns: an error or nothing if it works
    static func updatePassword(user: User,newpassword:String)->NSError?{
        let context = CoreDataManager.context
        user.password = newpassword
        if let error = CoreDataManager.save() {
            context.rollback()
            return error
        }
        else {
            print("User updated successfully")
            return nil
        }
    }
}
