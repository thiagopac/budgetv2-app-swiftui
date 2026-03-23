//
//  String+Extensions.swift
//  BudgetsAppV2
//
//  Created by Thiago Castro on 09/03/26.
//


import Foundation

extension String {
    var isEmptyOrWhitespace: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
