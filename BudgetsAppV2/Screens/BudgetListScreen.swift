//
//  BudgetListScreen.swift
//  BudgetsAppV2
//
//  Created by Thiago Castro on 09/03/26.
//


import SwiftUI

struct BudgetListScreen: View {
    
    @State private var isPresented: Bool = false
    @FetchRequest(sortDescriptors: []) private var budgets: FetchedResults<Budget>
    @State private var isPresentingFilter: Bool = false
    
    private var total: Double {
        budgets.reduce(0) { limit, budget in
            budget.limit + limit
        }
    }
    
    var body: some View {
        VStack {
            
            if budgets.isEmpty {
                ContentUnavailableView("No budgets avaiable", systemImage: "xmark")
            } else {
            
                List {
                    HStack {
                        Spacer()
                        Text("Total Limit")
                        Text(total, format: .currency(code: Locale.currencyCode))
                        Spacer()
                    }.font(.headline)
                    
                    ForEach(budgets) { budget in
                        NavigationLink {
                            BudgetDetailScreen(budget: budget)
                        } label: {
                            BudgetCellView(budget: budget)
                        }

                    }
                }
                
            }
            
        }.navigationTitle("Budget App")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Filter") {
                        isPresentingFilter.toggle()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Budget") {
                        isPresented = true
                    }
                }
            }
            .sheet(isPresented: $isPresented) {
                AddBudgetScreen()
                    .presentationDetents([.fraction(0.5)])
            }
            .sheet(isPresented: $isPresentingFilter) {
                FilterScreen()
                    .presentationDetents([.fraction(0.9)])
            }
    }
}

#Preview {
    NavigationStack {
        BudgetListScreen()
    }.environment(\.managedObjectContext, CoreDataProvider.preview.context)
}
