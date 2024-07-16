//
//  UserDefaultsExtensionTests.swift
//  SAppTests
//
//  Created by Kujtim Saliu on 16.7.24.
//

import XCTest
@testable import savings_app

class UserDefaultsExtensionTests: XCTestCase {
    
    let userDefaults = UserDefaults.standard
    
    override func tearDown() {
        userDefaults.removeUser()
        super.tearDown()
    }
    
    func testSetAndGetUser() {
        let user = User(id: 1, googleId: "12345", email: "test@example.com", name: "John Doe", givenName: "John", familyName: "Doe", pictureUrl: "https://example.com/picture.jpg", income: 50000)
        
        userDefaults.setUser(id: user.id, googleId: user.googleId, email: user.email, name: user.name, givenName: user.givenName, familyName: user.familyName, pictureUrl: user.pictureUrl, income: user.income)
        
        let retrievedUser = userDefaults.getUser()
        
        XCTAssertNotNil(retrievedUser)
        XCTAssertEqual(retrievedUser?.id, user.id)
        XCTAssertEqual(retrievedUser?.googleId, user.googleId)
        XCTAssertEqual(retrievedUser?.email, user.email)
        XCTAssertEqual(retrievedUser?.name, user.name)
        XCTAssertEqual(retrievedUser?.givenName, user.givenName)
        XCTAssertEqual(retrievedUser?.familyName, user.familyName)
        XCTAssertEqual(retrievedUser?.pictureUrl, user.pictureUrl)
        XCTAssertEqual(retrievedUser?.income, user.income)
    }
    
    func testRemoveUser() {
        let user = User(id: 1, googleId: "12345", email: "test@example.com", name: "John Doe", givenName: "John", familyName: "Doe", pictureUrl: "https://example.com/picture.jpg", income: 50000)
        
        userDefaults.setUser(id: user.id, googleId: user.googleId, email: user.email, name: user.name, givenName: user.givenName, familyName: user.familyName, pictureUrl: user.pictureUrl, income: user.income)
        
        XCTAssertNotNil(userDefaults.getUser())
        
        userDefaults.removeUser()
        
        XCTAssertNil(userDefaults.getUser())
    }
}
