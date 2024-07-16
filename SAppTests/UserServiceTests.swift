//
//  UserServiceTests.swift
//  SAppTests
//
//  Created by Kujtim Saliu on 16.7.24.
//

import XCTest
@testable import savings_app
import GoogleSignIn

class UserServiceTests: XCTestCase {
    
    var userService: UserService!
    
    override func setUp() {
        super.setUp()
        userService = UserService.shared
    }
    
    override func tearDown() {
        userService = nil
        super.tearDown()
    }
    
    func testCreateOrFetchUser() {
        let expectation = self.expectation(description: "Create or fetch user")
        
        // Create a mock GIDGoogleUser
        let mockUser = MockGIDGoogleUser()
        
        userService.createOrFetchUser(googleUser: mockUser) { result in
            switch result {
            case .success(let user):
                XCTAssertEqual(user.googleId, "mockGoogleId")
                XCTAssertEqual(user.email, "mock@example.com")
                XCTAssertEqual(user.name, "Mock User")
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

// Mock GIDGoogleUser for testing
class MockGIDGoogleUser: GIDGoogleUser {
    override var userID: String? { return "mockGoogleId" }
    override var profile: GIDProfileData? {
        return MockGIDProfileData()
    }
}

class MockGIDProfileData: GIDProfileData {
    override var email: String { return "mock@example.com" }
    override var name: String { return "Mock User" }
    override var givenName: String { return "Mock" }
    override var familyName: String { return "User" }
    override func imageURL(withDimension dimension: UInt) -> URL? {
        return URL(string: "https://example.com/mock.jpg")
    }
}
