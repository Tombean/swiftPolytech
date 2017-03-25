//
//  Helper.swift
//  Zboobee
//
//  Created by Laure MARCHAL on 24/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import UIKit

/// Class that serves to implement function that we need everywhere
class Helper{
    
    /// function to have the current date on a good format to read
    ///
    /// - Returns: a string that is a good format of the date
    class func getCurrentDate()->String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let dateToSting = formatter.string(from: date)
        return dateToSting
    }
    
    /// function to transform date on a good format to read
    ///
    /// - Parameter date: date we want to transform
    /// - Returns: a string that is the good format of the date
    class func getFormattedDate(date:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let dateToSting = formatter.string(from: date)
        return dateToSting
    }
}
