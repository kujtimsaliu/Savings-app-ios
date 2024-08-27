//
//  AppCordinator.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//


import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

protocol CoordinatorDelegate: AnyObject {
    func coordinatorDidFinish(_ coordinator: Coordinator)
}

class AppCoordinator: Coordinator {
    let window: UIWindow
    var childCoordinators = [Coordinator]()

    init(window: UIWindow){
        self.window = window
    }

    func start() {
        if UserDefaults.standard.hasCompletedOnboarding() {
            showMainApp()
        } else {
            showOnboarding()
        }
    }

    private func showOnboarding() {
        let navigationController = UINavigationController()
        let onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        onboardingCoordinator.delegate = self
        childCoordinators.append(onboardingCoordinator)
        onboardingCoordinator.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    private func showMainApp(){
        let tabBarCoordinator = TabBarCoordinator(window: window)
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
    }
}

extension AppCoordinator: CoordinatorDelegate {
    func coordinatorDidFinish(_ coordinator: Coordinator) {
        if coordinator is OnboardingCoordinator {
            childCoordinators = childCoordinators.filter { $0 !== coordinator }
            UserDefaults.standard.setOnboardingCompleted()
            showMainApp()
        }
    }
}
