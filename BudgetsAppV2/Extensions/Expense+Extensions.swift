//
//  Expense+Extensions.swift
//  BudgetsAppV2
//
//  Created by Thiago Castro on 19/03/26.
//


import Foundation

extension Expense {
    
    var tagsArray: [Tag] {
        let set = tags as? Set<Tag> ?? []
        return set.sorted { ($0.name ?? "") < ($1.name ?? "") }
    }
    
}
