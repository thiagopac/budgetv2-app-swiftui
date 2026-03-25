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
    
    var spent: Double {
        
        guard let expenses = expenses as? Set<Expense> else { return 0 }
        
        return expenses.reduce(0) { partialResult, expense in
            partialResult + expense.amount
        }
    }
    
    var remaining: Double {
        limit - spent
    }
    
}
