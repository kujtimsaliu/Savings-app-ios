//
//  AuthResponse.swift
//  savings-app
//
//  Created by Kujtim Saliu on 17.7.24.
//

import Foundation


struct AuthResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let user: User

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case user
    }
}
