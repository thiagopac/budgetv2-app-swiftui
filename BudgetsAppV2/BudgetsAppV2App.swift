//
//  BudgetsAppV2App.swift
//  BudgetsAppV2
//
//  Created by Thiago Castro on 09/03/26.
//


import SwiftUI

@main
struct BudgetsAppV2App: App {
    
    let provider: CoreDataProvider
    let tagSeeder: TagSeeder
    
    init() {
        provider = CoreDataProvider()
        tagSeeder = TagSeeder(context: provider.context)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                BudgetListScreen()
            }
            .environment(\.managedObjectContext, provider.context)
                .onAppear {
                    let hasSeededData = UserDefaults.standard.bool(forKey: "hasSeedData")
                    
                    if !hasSeededData {
                        let commonTags = ["Food", "Dining", "Travel", "Shopping", "Transportation", "Utilities", "Groceries", "Health", "Education"]
                        
                        do {
                            try tagSeeder.seed(commonTags)
                            UserDefaults.standard.setValue(true, forKey: "hasSeedData")
                        } catch {
                            print(error)
                        }
                        
                    }
                    
                }
        }
    }
}
