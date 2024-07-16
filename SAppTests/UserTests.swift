//
//  UserTests.swift
//  SAppTests
//
//  Created by Kujtim Saliu on 16.7.24.
//

import XCTest
@testable import savings_app

class UserTests: XCTestCase {
    
    func testUserInitialization() {
        let user = User(id: 1, googleId: "12345", email: "test@example.com", name: "John Doe", givenName: "John", familyName: "Doe", pictureUrl: "https://example.com/picture.jpg", income: 50000)
        
        XCTAssertEqual(user.id, 1)
        XCTAssertEqual(user.googleId, "12345")
        XCTAssertEqual(user.email, "test@example.com")
        XCTAssertEqual(user.name, "John Doe")
        XCTAssertEqual(user.givenName, "John")
        XCTAssertEqual(user.familyName, "Doe")
        XCTAssertEqual(user.pictureUrl, "https://example.com/picture.jpg")
        XCTAssertEqual(user.income, 50000)
    }
    
    func testUserCoding() throws {
        let user = User(id: 1, googleId: "12345", email: "test@example.com", name: "John Doe", givenName: "John", familyName: "Doe", pictureUrl: "https://example.com/picture.jpg", income: 50000)
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(user)
        
        let decoder = JSONDecoder()
        let decodedUser = try decoder.decode(User.self, from: data)
        
        XCTAssertEqual(user.id, decodedUser.id)
        XCTAssertEqual(user.googleId, decodedUser.googleId)
        XCTAssertEqual(user.email, decodedUser.email)
        XCTAssertEqual(user.name, decodedUser.name)
        XCTAssertEqual(user.givenName, decodedUser.givenName)
        XCTAssertEqual(user.familyName, decodedUser.familyName)
        XCTAssertEqual(user.pictureUrl, decodedUser.pictureUrl)
        XCTAssertEqual(user.income, decodedUser.income)
    }
}
