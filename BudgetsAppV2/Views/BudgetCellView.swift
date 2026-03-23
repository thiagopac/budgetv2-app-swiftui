//
//  BudgetCellView.swift
//  BudgetsAppV2
//
//  Created by Thiago Castro on 12/03/26.
//

import SwiftUI

struct BudgetCellView: View {
    
    let budget: Budget
    
    var body: some View {
        HStack {
            Text(budget.title ?? "")
            Spacer()
            Text(budget.limit, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
        }
    }
}
