//
//  Extensions.swift
//  savings-app
//
//  Created by Kujtim Saliu on 15.7.24.
//

import UIKit

import UIKit

extension UserDefaults {
    private enum UserKeys: String {
        case userId
        case userGoogleId
        case userEmail
        case userName
        case userGivenName
        case userFamilyName
        case userPictureUrl
        case userIncome
    }
    
    func setUser(id: String, googleId: String, email: String, name: String, givenName: String, familyName: String, pictureUrl: String, income: Double?) {
        set(id, forKey: UserKeys.userId.rawValue)
        set(googleId, forKey: UserKeys.userGoogleId.rawValue)
        set(email, forKey: UserKeys.userEmail.rawValue)
        set(name, forKey: UserKeys.userName.rawValue)
        set(givenName, forKey: UserKeys.userGivenName.rawValue)
        set(familyName, forKey: UserKeys.userFamilyName.rawValue)
        set(pictureUrl, forKey: UserKeys.userPictureUrl.rawValue)
        set(income, forKey: UserKeys.userIncome.rawValue)
    }
    
    func getUser() -> User? {
        guard let id = object(forKey: UserKeys.userId.rawValue) as? String,
              let googleId = string(forKey: UserKeys.userGoogleId.rawValue),
              let email = string(forKey: UserKeys.userEmail.rawValue),
              let name = string(forKey: UserKeys.userName.rawValue),
              let givenName = string(forKey: UserKeys.userGivenName.rawValue),
              let familyName = string(forKey: UserKeys.userFamilyName.rawValue),
              let pictureUrl = string(forKey: UserKeys.userPictureUrl.rawValue) else {
            return nil
        }
        
        let income = double(forKey: UserKeys.userIncome.rawValue)
        
        return User(id: id, googleId: googleId, email: email, name: name, givenName: givenName, familyName: familyName, pictureUrl: pictureUrl, income: income)
    }
    
    func removeUser() {
        removeObject(forKey: UserKeys.userId.rawValue)
        removeObject(forKey: UserKeys.userGoogleId.rawValue)
        removeObject(forKey: UserKeys.userEmail.rawValue)
        removeObject(forKey: UserKeys.userName.rawValue)
        removeObject(forKey: UserKeys.userGivenName.rawValue)
        removeObject(forKey: UserKeys.userFamilyName.rawValue)
        removeObject(forKey: UserKeys.userPictureUrl.rawValue)
        removeObject(forKey: UserKeys.userIncome.rawValue)
    }
}
