//
//  TabBarCoordinator.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//

import UIKit

class TabBarCoordinator: Coordinator {
    let window: UIWindow
    var childCoordinators = [Coordinator]()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let tabBarController = UITabBarController()
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        let expensesVC = ExpensesViewController()
        expensesVC.tabBarItem = UITabBarItem(title: "Expenses", image: UIImage(systemName: "dollarsign.circle"), tag: 1)
        
        let aiInsightsVC = AIViewController()
        aiInsightsVC.tabBarItem = UITabBarItem(title: "AI Insights", image: UIImage(systemName: "brain"), tag: 2)
        
        let budgetsVC = BudgetsViewController()
        budgetsVC.tabBarItem = UITabBarItem(title: "Budgets", image: UIImage(systemName: "chart.pie"), tag: 3)
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 4)
        
        tabBarController.viewControllers = [homeVC, expensesVC, aiInsightsVC, budgetsVC, profileVC].map { UINavigationController(rootViewController: $0) }
        
        tabBarController.tabBar.backgroundColor = .systemBackground
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }}
