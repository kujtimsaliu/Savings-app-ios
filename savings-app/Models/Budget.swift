//
//  Budget.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//

import Foundation

struct Budget: Codable {
    let id: Int
    let name: String
    let amount: Double
    let frequency: BudgetFrequency
    let startDate: Date
    let createdAt: Date
    let ownerId: Int
    var remainingAmount: Double
    let savingsGoal: Double
    let notifyWhenClose: Bool
}

enum BudgetFrequency: String, Codable {
    case daily, monthly, once
}

