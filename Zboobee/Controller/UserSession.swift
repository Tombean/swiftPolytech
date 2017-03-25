//
//  Session.swift
//  Zboobee
//
//  Created by Laure Marchal on 22/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation

///Singleton that is used to know the user everywhere in the application
class UserSession {
    static let instance = UserSession()
    var user : User? = nil
    
    private init(){
        
    }
}
