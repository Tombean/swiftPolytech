//
//  AppDelegate.swift
//  Zboobee
//
//  Created by Laure MARCHAL on 13/02/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let context =  CoreDataManager.context
        //set the promotions in the base at the start of the application
        var dataToSave : Bool = false
        if UsersSet.findAllPromotion() == nil {
            let IG3 : Promotion = Promotion(context: context)
            IG3.specialty = "IG"
            IG3.graduationYear = 2019
            let IG4 : Promotion = Promotion(context: context)
            IG4.specialty = "IG"
            IG4.graduationYear = 2018
            let IG5 : Promotion = Promotion(context: context)
            IG5.specialty = "IG"
            IG5.graduationYear = 2017
            dataToSave = true
        }
        //set the groups in the base at the start of the application
        if GroupsSet.findAllGroups() == nil {
            let teachers : Group = Group(context: context)
            teachers.name = "Teacher"
            let office : Group = Group(context: context)
            office.name = "Office"
            let students : Group = Group(context: context)
            students.name = "Students"
            
            let IG3Class : Group = Group(context: context)
            IG3Class.name = "IG3"
            let IG4Class : Group = Group(context: context)
            IG4Class.name = "IG4"
            let IG5Class : Group = Group(context: context)
            IG5Class.name = "IG5"
            let IG3ClassTeacher : Group = Group(context: context)
            IG3ClassTeacher.name = "IG3 - Teacher"
            let IG4ClassTeacher : Group = Group(context: context)
            IG4ClassTeacher.name = "IG4 - Teacher"
            let IG5ClassTeacher : Group = Group(context: context)
            IG5ClassTeacher.name = "IG5 - Teacher"
            dataToSave = true
        }
        //set an office in the base
        if UsersSet.findOffice(email:"office@umontpellier.fr") == nil{
            let office : Office = Office(context: context)
            office.lastname = "tortosa"
            office.firstname = "helene"
            office.mailUniv = "office@umontpellier.fr"
            office.password = "password"
            let promos = UsersSet.findAllPromotion()
            let pr : NSSet? = promos as? NSSet
            office.promotions = pr
            let groups : NSSet = [GroupsSet.findGroupByName(name: "Teacher")!,GroupsSet.findGroupByName(name: "Office")!,GroupsSet.findGroupByName(name: "IG5 - Teacher")!,GroupsSet.findGroupByName(name: "IG4 - Teacher")!,GroupsSet.findGroupByName(name: "IG3 - Teacher")!,GroupsSet.findGroupByName(name: "IG5")!,GroupsSet.findGroupByName(name: "IG4")!,GroupsSet.findGroupByName(name: "IG3")!]
            office.groups = groups
            dataToSave = true
        }
        if dataToSave{
            do {
                try context.save()
            
            } catch {
                fatalError("couldn't save context when saving promos")
            }
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Zboobee")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

