//
//  Helper.swift
//  Zboobee
//
//  Created by Laure MARCHAL on 24/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import UIKit

class Helper{
    
    class func getCurrentDate()->String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let dateToSting = formatter.string(from: date)
        return dateToSting
    }
    
    class func getFormattedDate(date:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let dateToSting = formatter.string(from: date)
        return dateToSting
    }
}
