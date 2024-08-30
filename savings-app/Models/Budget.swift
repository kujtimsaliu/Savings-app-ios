//
//  Budget.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//

import Foundation

struct Budget: Codable {
    let id: Int
    let amount: Double
    let frequency: BudgetFrequency
    let startDate: Date
    let createdAt: Date
    let ownerId: Int
    
    enum CodingKeys: String, CodingKey {
        case id, amount, frequency
        case startDate = "start_date"
        case createdAt = "created_at"
        case ownerId = "owner_id"
    }
}

enum BudgetFrequency: String, Codable {
    case daily
    case monthly
    case once
}

