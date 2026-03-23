//
//  BudgetDetailScreen.swift
//  BudgetsAppV2
//
//  Created by Thiago Castro on 12/03/26.
//


import SwiftUI
import CoreData

struct BudgetDetailScreen: View {
    
    let budget: Budget
    
    @Environment(\.managedObjectContext) private var context
    
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
    
    init(budget: Budget){
        self.budget = budget
        
        _expenses = FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "budget == %@", budget))
    }
    
    @State private var title: String = ""
    @State private var amount: Double?
    @State private var selectedTags: Set<Tag> = []
    
    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace && amount != nil && Double(amount!) > 0 && !selectedTags.isEmpty
    }
    
    private var total: Double {
        return expenses.reduce(0) { partialResult, expense in
            partialResult + expense.amount
        }
    }
    
    private var remaining: Double {
        budget.limit - total
    }
    
    private func addExpense() {
        let expense = Expense(context: context)
        expense.title = title
        expense.amount = amount ?? 0
        expense.dateCreated = Date()
        
        budget.addToExpenses(expense)
        
        expense.addToTags(NSSet(set: selectedTags))
        
        do {
            try context.save()
            
            title = ""
            amount = nil
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func deleteExpense(_ indexSet: IndexSet) {
        indexSet.forEach { index in
            let expense = expenses[index]
            context.delete(expense)
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        
        VStack {
            Text(budget.limit, format: .currency(code: Locale.currencyCode))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
        
        Form {
            Section("New expense") {
                TextField("Title", text: $title)
                
                TextField("Amount", value: $amount, format: .currency(code: Locale.currencyCode))
                
                TagsView(selectedTags: $selectedTags)
                
                Button {
                    addExpense()
                } label: {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!isFormValid)
            }
            
            Section("Expenses") {
                List{
                    VStack(alignment: .leading) {
                        
                        HStack {
                            Spacer()
                            Text("Total")
                            Text(total, format: .currency(code: Locale.currencyCode))
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            Text("Remaining")
                            Text(remaining, format: .currency(code: Locale.currencyCode))
                                .foregroundStyle(remaining < 0 ? .red : .green)
                            Spacer()
                        }
                    }
                    
                    ForEach(expenses) { expense in
                        ExpenseCellView(expense: expense)
                    }.onDelete(perform: deleteExpense)
                }
            }
            
        }.navigationTitle(budget.title ?? "")
    }
}

struct BudgetDetailScreenContainer: View {
    
    @FetchRequest(sortDescriptors: []) private var budgets: FetchedResults<Budget>
    
    var body: some View {
        BudgetDetailScreen(budget: budgets.first(where: { $0.title == "Entertaiment" })!)
    }
}



#Preview {
    NavigationStack {
        BudgetDetailScreenContainer()
            .environment(\.managedObjectContext, CoreDataProvider.preview.context)
    }
}
