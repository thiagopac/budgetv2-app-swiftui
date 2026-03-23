//
//  TagSeeder.swift
//  BudgetsAppV2
//
//  Created by Thiago Castro on 18/03/26.
//


import Foundation
import CoreData

class TagSeeder {
    
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func seed(_ commonTags: [String]) throws {
        
        for commonTag in commonTags {
            let tag = Tag(context: context)
            tag.name = commonTag
            
            try context.save()
        }
        
    }
    
}
