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
    
    /// <#Description#>
    ///
    /// - Parameter email: email address of the user
    /// - Returns: Returns the user who has the email given as a parameter, nothing if no user was found
func finduser(email: String)->User?{
    var users : [User]
    let context = CoreDataManager.context
    let requestUser: NSFetchRequest<User> = User.fetchRequest()
    requestUser.predicate = NSPredicate(format: "email == %@", email)
    do{
        try users = context.fetch(requestUser)
    }catch{
        return nil
    }
    return users[0]
}
    
    /// <#Description#>
    ///
    /// - Parameter email: email address of the user
    /// - Parameter password: password of the user
    /// - Returns: Returns the user who has the email given as a parameter, nothing if no user was found
func canLogin(email: String, password: String)->Bool{
    let user : User? = self.finduser(email: email)
    return user?.password == password
}
    
    func aaaa(){
        print("aaa")
    }
    
}
