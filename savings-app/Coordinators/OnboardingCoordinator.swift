//
//  OnboardingCoordinator.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//

import UIKit

class OnboardingCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    weak var delegate: CoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let welcomeVC = WelcomeViewController()
        welcomeVC.delegate = self
        navigationController.setViewControllers([welcomeVC], animated: false)
    }
}

extension OnboardingCoordinator: OnboardingViewControllerDelegate {
    func didFinishOnboarding() {
        delegate?.coordinatorDidFinish(self)
    }

    func moveToNextScreen(_ currentViewController: UIViewController) {
        let nextVC: UIViewController
        
        switch currentViewController {
        case is WelcomeViewController:
            nextVC = NameViewController()
        case is NameViewController:
            nextVC = FinancialGoalsViewController()
        case is FinancialGoalsViewController:
            nextVC = IncomeViewController()
        case is IncomeViewController:
            nextVC = ExpenseCategoriesViewController()
        case is ExpenseCategoriesViewController:
            nextVC = SetupCompleteViewController()
        default:
            return
        }
        
        (nextVC as? OnboardingViewController)?.delegate = self
        navigationController.pushViewController(nextVC, animated: true)
    }
}

