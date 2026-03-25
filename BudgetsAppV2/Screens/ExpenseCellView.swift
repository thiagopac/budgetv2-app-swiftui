//
//  ExpenseCellView.swift
//  BudgetsAppV2
//
//  Created by Thiago Castro on 16/03/26.
//

import SwiftUI


struct ExpenseCellView: View {
    
    var expense: Expense
    
    var body: some View {
        VStack {
            HStack {
                Text(expense.title ?? "")
                Text(String(expense.quantity))
                Spacer()
                Text(expense.total, format: .currency(code: Locale.currencyCode))
            }
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(expense.tagsArray) { tag in
                        Text(tag.name ?? "")
                            .font(.caption)
                            .foregroundStyle(.white)
                            .padding(6)
                            .background(.blue)
                            .clipShape(.capsule)
                    }
                }
            }
        }
    }
}

struct ExpenseCellViewContainer: View {
    
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>

    var body: some View {
        ExpenseCellView(expense: expenses[0])
    }
}

#Preview {
    ExpenseCellViewContainer()
        .environment(\.managedObjectContext, CoreDataProvider.preview.context)
}
