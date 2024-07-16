//
//  TabBarCordinatorTests.swift
//  SAppTests
//
//  Created by Kujtim Saliu on 16.7.24.
//

import XCTest
@testable import savings_app

class TabBarCoordinatorTests: XCTestCase {
    
    var window: UIWindow!
    var tabBarCoordinator: TabBarCoordinator!
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        tabBarCoordinator = TabBarCoordinator(window: window)
    }
    
    override func tearDown() {
        window = nil
        tabBarCoordinator = nil
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertNotNil(tabBarCoordinator)
        XCTAssertEqual(tabBarCoordinator.window, window)
        XCTAssertTrue(tabBarCoordinator.childCoordinators.isEmpty)
    }
    
    func testStart() {
        tabBarCoordinator.start()
        
        XCTAssertTrue(window.rootViewController is UITabBarController)
        
        guard let tabBarController = window.rootViewController as? UITabBarController else {
            XCTFail("Root view controller should be UITabBarController")
            return
        }
        
        XCTAssertEqual(tabBarController.viewControllers?.count, 5)
        
        XCTAssertTrue(tabBarController.viewControllers?[0] is UINavigationController)
        XCTAssertTrue((tabBarController.viewControllers?[0] as? UINavigationController)?.topViewController is HomeViewController)
        
        XCTAssertTrue(tabBarController.viewControllers?[1] is UINavigationController)
        XCTAssertTrue((tabBarController.viewControllers?[1] as? UINavigationController)?.topViewController is ExpensesViewController)
        
        XCTAssertTrue(tabBarController.viewControllers?[2] is UINavigationController)
        XCTAssertTrue((tabBarController.viewControllers?[2] as? UINavigationController)?.topViewController is AIViewController)
        
        XCTAssertTrue(tabBarController.viewControllers?[3] is UINavigationController)
        XCTAssertTrue((tabBarController.viewControllers?[3] as? UINavigationController)?.topViewController is BudgetsViewController)
        
        XCTAssertTrue(tabBarController.viewControllers?[4] is UINavigationController)
        XCTAssertTrue((tabBarController.viewControllers?[4] as? UINavigationController)?.topViewController is ProfileViewController)
    }
}
