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
    
    var body: some View {
        VStack {
            List(budgets) { budget in
                NavigationLink {
                    BudgetDetailScreen(budget: budget)
                } label: {
                    BudgetCellView(budget: budget)
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
