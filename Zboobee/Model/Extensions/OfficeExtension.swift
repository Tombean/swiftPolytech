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
    static func createOffice(firstname: String,lastname: String, email: String, password: String, promotions: NSSet)->Office?{
        
        let newOffice : Office? = nil
        newOffice?.firstname = firstname
        newOffice?.lastname = lastname
        newOffice?.mailUniv = email
        // ATTENTION CRYPTER LE PASSWORD PLUS TARD
        newOffice?.password = password
        newOffice?.promotions = promotions
        
        return newOffice
    }
}
