//
//  User.swift
//  savings-app
//
//  Created by Kujtim Saliu on 7.7.24.
//

import Foundation

struct User: Codable {
    let id: Int
    let googleId: String
    let email: String
    let name: String
    let givenName: String
    let familyName: String
    let pictureUrl: String
    var income: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case googleId = "google_id"
        case email
        case name
        case givenName = "given_name"
        case familyName = "family_name"
        case pictureUrl = "picture_url"
        case income
    }
}
