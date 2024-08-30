//
//  BudgetsViewModel.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//

import UIKit

class BudgetsViewModel {
    private(set) var budgets: [Budget] = [] {
        didSet {
            budgetsDidChange?()
        }
    }
    
    var budgetsDidChange: (() -> Void)?
    
    func fetchBudgets() {
        // Implement API call to fetch budgets
        BudgetService.shared.getBudgets { [weak self] result in
            switch result {
            case .success(let budgets):
                self?.budgets = budgets
            case .failure(let error):
                print("Error fetching budgets: \(error)")
                // Handle error (e.g., show an alert)
            }
        }
    }
    
    func addBudget(_ budget: Budget) {
        BudgetService.shared.createBudget(budget) { [weak self] result in
            switch result {
            case .success(let newBudget):
                self?.budgets.append(newBudget)
            case .failure(let error):
                print("Error adding budget: \(error)")
                // Handle error (e.g., show an alert)
            }
        }
    }
}
