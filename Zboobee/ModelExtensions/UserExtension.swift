//
//  UserExtension.swift
//  Zboobee
//
//  Created by Tom SOMERVILLE-ROBERTS on 02/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import CoreData

extension User{
   func findUser(email: String)->User?{
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
}
