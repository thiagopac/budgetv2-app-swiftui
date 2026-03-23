//
//  Budget+Extensions.swift
//  BudgetsAppV2
//
//  Created by Thiago Castro on 10/03/26.
//


import Foundation
import CoreData

extension Budget {
    
    static func exists(context: NSManagedObjectContext, title: String) -> Bool {
        
        let request = Budget.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let results = try context.fetch(request)
            return !results.isEmpty
        } catch {
            return false
        }
        
    }
    
}
