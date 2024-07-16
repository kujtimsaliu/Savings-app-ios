//
//  HomeViewControllerTests.swift
//  SAppTests
//
//  Created by Kujtim Saliu on 16.7.24.
//

import XCTest
@testable import savings_app

class HomeViewControllerTests: XCTestCase {
    
    var homeViewController: HomeViewController!
    
    override func setUp() {
        super.setUp()
        homeViewController = HomeViewController()
    }
    
    override func tearDown() {
        homeViewController = nil
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertNotNil(homeViewController)
    }
    
    func testViewDidLoad() {
        homeViewController.viewDidLoad()
        
        XCTAssertEqual(homeViewController.view.backgroundColor, .primaryBackgroundColor)
        XCTAssertEqual(homeViewController.title, "Home")
    }
}
