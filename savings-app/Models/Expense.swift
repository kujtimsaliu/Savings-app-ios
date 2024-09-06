//
//  Expense.swift
//  savings-app
//
//  Created by Kujtim Saliu on 3.7.24.
//

import Foundation

struct ExpenseCreate: Codable {
    let amount: Float
    let category: String
    let date: Date
    let description: String?
}

struct ExpenseUpdate: Codable {
    let amount: Float
    let category: String
    let date: Date
    let description: String?
}

struct Expense: Codable {
    let id: String
    let amount: Double
    let category: String
    let description: String
    let date: Date
    let paymentMethod: String
    let isRecurring: Bool
    let recurringFrequency: String?
    let hasReminder: Bool
}
