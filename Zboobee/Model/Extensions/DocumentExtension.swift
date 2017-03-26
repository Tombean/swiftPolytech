//
//  DocumentExtension.swift
//  Zboobee
//
//  Created by Laure MARCHAL on 24/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation

///extension of the object Document in the core
extension Document{
    
    
    /// create a Document
    ///
    /// - Parameters:
    ///   - title: title of the document
    ///   - url: url of the document
    ///   - originator: user who posted the document
    ///   - groups: groups who can see the document
    /// - Returns: a Document
    static func createDocument(title:String,url:String,originator:User,groups: NSSet)->Document{
        
        let context = CoreDataManager.context
        let newDocument : Document = Document(context: context)
        newDocument.title = title
        newDocument.url = url
        newDocument.isPosted = originator
        newDocument.groups = groups
        
        return newDocument
    }
    
    static func deleteDocument(document: Document)->NSError?{
        let context = CoreDataManager.context
        context.delete(document)
        if let error = CoreDataManager.save() {
            context.rollback()
            return error
        }
        else {
            print("User deleted successfully")
            return nil
        }
    }
}
