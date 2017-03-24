//
//  DocumentExtension.swift
//  Zboobee
//
//  Created by Laure MARCHAL on 24/03/2017.
//  Copyright © 2017 Laure MARCHAL. All rights reserved.
//

import Foundation

extension Document{
    
    
    /// create a Document
    ///
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
    
    
}
