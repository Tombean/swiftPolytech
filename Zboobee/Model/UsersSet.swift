//
//  UsersSet.swift
//  Zboobee
//
//  Created by Tom SOMERVILLE-ROBERTS on 02/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation
import CoreData

///Class that manages the collection of users in the core
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
        return canlogin
    }
    static func findStudent(email: String)->Student?{
        var students : [Student] = []
        let context = CoreDataManager.context
        let requestUser: NSFetchRequest<Student> = Student.fetchRequest()
        requestUser.predicate = NSPredicate(format: "mailUniv == %@", email)
        do{
            try students = context.fetch(requestUser)
        }catch{
            return nil
        }
        if students.count > 0{
            return students[0]
        }
        else{
            return nil
        }
    }
    
    
    /// check if a student's account is valide
    ///
    /// - Parameter email: email address of the student
    /// - Returns: Returns true if he can login or false
    static func isValideStud(email: String)->Bool{
        let stud : Student? = self.findStudent(email: email)
        return (stud?.accountValidate)!
    }
    
    /// find a teacher
    ///
    /// - Parameter email: email of the teacher
    /// - Returns: the teacher found
    static func findTeacher(email: String)->Teacher?{
        var teachers : [Teacher] = []
        let context = CoreDataManager.context
        let requestUser: NSFetchRequest<Teacher> = Teacher.fetchRequest()
        requestUser.predicate = NSPredicate(format: "mailUniv == %@", email)
        do{
            try teachers = context.fetch(requestUser)
        }catch{
            return nil
        }
        if teachers.count > 0{
            return teachers[0]
        }
        else{
            return nil
        }
    }
    
    
    /// check if a teacher's account is valide
    ///
    /// - Parameter email: email address of the teacher
    /// - Returns: Returns true if he can login or false
    static func isValideTeach(email: String)->Bool{
        let teach : Teacher? = self.findTeacher(email: email)
        return (teach?.accountValidate)!
    }
    
    /// add a student to the collection
    ///
    /// - Parameter studentToAdd: object student
    /// - Returns: true if the student is added
    static func addStudent(studentToAdd : Student)->Bool{
        let context = studentToAdd.managedObjectContext
        do {
            try context?.save()
        } catch {
            return false
        }
        return true
    }
    
    /// add a teacher to the collection
    ///
    /// - Parameter teacherToAdd: object teacher
    /// - Returns: true if the teacher is added
    static func addTeacher(teacherToAdd : Teacher)->Bool{
        let context = teacherToAdd.managedObjectContext
        do {
            try context?.save()
        } catch {
            return false
        }
        return true
    }
    
    /// add an office to the collection
    ///
    /// - Parameter officeToAdd: object office
    /// - Returns: true if the office is added
    static func addOffice(officeToAdd : Office)->Bool{
        let context = officeToAdd.managedObjectContext
        do {
            try context?.save()
        } catch {
            return false
        }
        return true
    }

    
    // MARK: - Promo management -
    
    
    /// find all the prom in the core
    ///
    /// - Returns: an array of promotion
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
    
    /// find a promo
    ///
    /// - Parameters:
    ///   - specialty: specialty
    ///   - year: graduation year
    /// - Returns: promotion found
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
    
    //MARK : Office management
    
    /// find an office
    ///
    /// - Parameter email: email of the office
    /// - Returns: Office found
    static func findOffice(email:String)->Office?{
        var office : [Office] = []
        let requestOffice: NSFetchRequest<Office> = Office.fetchRequest()
        requestOffice.predicate = NSPredicate(format: "mailUniv == %@", email)
        let context = CoreDataManager.context
        do{
            try office = context.fetch(requestOffice)
        }catch{
            return nil
        }
        if office.count > 0{
            return office[0]
        }
        else{
            return nil
        }
    }
    
    //MARK : Teacher management
    
    /// get all the teachers
    ///
    /// - Returns: an array of teachers
    static func getAllTeachers()->[Teacher]{
        var teachers : [Teacher] = []
        let requestTeacher: NSFetchRequest<Teacher> = Teacher.fetchRequest()
        let context = CoreDataManager.context
        do{
            try teachers = context.fetch(requestTeacher)
        }catch{
            return []
        }
        return teachers
    }
    
}
