//
//  CoreDataProvider.swift
//  BudgetsAppV2
//
//  Created by Thiago Castro on 09/03/26.
//


import Foundation
import CoreData

class CoreDataProvider {
    
    let persistentContainer: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    static var preview: CoreDataProvider {
        
        let provider = CoreDataProvider(inMemory: true)
        let context = provider.context
        
        let categoriesNames = ["Entertaiment", "Food", "Car"]
        let expensesNames = ["Movies", "Milk", "Insurance"]
        
        for index in 0...2 {
            let cat = Budget(context: context)
            cat.title = categoriesNames[index]
            cat.limit = Double((index + 1) * 100)
            cat.dateCreated = Date()
            
            let exp = Expense(context: context)
            exp.title = expensesNames[index]
            exp.amount = Double(index + 1) * 3.50
            exp.dateCreated = Date()
            
            cat.addToExpenses(exp)
        }
        
        let commonTags = ["Food", "Dining", "Travel", "Shopping", "Transportation", "Utilities", "Groceries", "Health", "Education"]
        for tagName in commonTags {
            let tag = Tag(context: context)
            tag.name = tagName
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
        
        return provider
    }
    
    init(inMemory: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "BudgetsAppModel")
        
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Core Data store failed to initialize \(error)")
            }
        }
    }
}
