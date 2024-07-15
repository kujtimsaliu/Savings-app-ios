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
    let id: Int
    let amount: Float
    let category: String
    let date: Date
    let description: String?
    let ownerId: Int
}
