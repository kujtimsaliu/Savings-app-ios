//
//  User.swift
//  savings-app
//
//  Created by Kujtim Saliu on 7.7.24.
//

import Foundation

struct User: Codable {
    let id: Int
    let email: String
    let name: String
    let income: Double
    let googleId: String?

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case income
        case googleId = "google_id"
    }
}
