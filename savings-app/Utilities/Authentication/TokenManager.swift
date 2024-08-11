//
//  TokenManager.swift
//  savings-app
//
//  Created by Kujtim Saliu on 17.7.24.
//

import Foundation
import KeychainAccess

class TokenManager {
    private let keychain = Keychain(service: "com.yourapp.tokens")
    
    func saveTokens(accessToken: String, refreshToken: String) {
        do {
            try keychain.set(accessToken, key: "accessToken")
            try keychain.set(refreshToken, key: "refreshToken")
        } catch {
            print("Error saving tokens: \(error)")
        }
    }
    
    func getAccessToken() -> String? {
        return try? keychain.get("accessToken")
    }
    
    func getRefreshToken() -> String? {
        return try? keychain.get("refreshToken")
    }
    
    func clearTokens() {
        do {
            try keychain.remove("accessToken")
            try keychain.remove("refreshToken")
        } catch {
            print("Error clearing tokens: \(error)")
        }
    }
}
