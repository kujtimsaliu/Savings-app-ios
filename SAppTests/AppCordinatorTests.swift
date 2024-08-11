//
//  AppCordinatorTests.swift
//  SAppTests
//
//  Created by Kujtim Saliu on 16.7.24.
//

import XCTest
@testable import savings_app

class AppCoordinatorTests: XCTestCase {
    
    var window: UIWindow!
    var appCoordinator: AppCoordinator!
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        appCoordinator = AppCoordinator(window: window)
    }
    
    override func tearDown() {
        window = nil
        appCoordinator = nil
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertNotNil(appCoordinator)
        XCTAssertEqual(appCoordinator.window, window)
        XCTAssertTrue(appCoordinator.childCoordinators.isEmpty)
    }
    
    func testStart() {
        appCoordinator.start()
        XCTAssertEqual(appCoordinator.childCoordinators.count, 1)
        XCTAssertTrue(appCoordinator.childCoordinators.first is OnboardingCoordinator)
    }
}

