//
//  Locale+Extensions.swift
//  BudgetsAppV2
//
//  Created by Thiago Castro on 16/03/26.
//


import Foundation

extension Locale {
    
    static var currencyCode: String {
        Locale.current.currency?.identifier ?? "USD"
    }
}
