//
//  CoreDataManager.swift
//  Zboobee
//
//  Created by Tom SOMERVILLE-ROBERTS on 02/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager: NSObject{
    
    
    static var context : NSManagedObjectContext = {
        guard let appDelegate =  UIApplication.shared.delegate as? AppDelegate else{
            exit(EXIT_FAILURE)
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    @discardableResult
    class func save() -> NSError?{
        do{
            try CoreDataManager.context.save()
            return nil
        }
        catch let error as NSError{
            return error
        }
    }
    
    
    
    
}
