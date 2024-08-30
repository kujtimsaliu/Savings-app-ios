//
//  BudgetsViewModel.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//

import Foundation

class BudgetsViewModel {
    private(set) var budgets: [Budget] = [] {
        didSet {
            saveBudgetsLocally()
            budgetsDidChange?()
        }
    }
    
    var budgetsDidChange: (() -> Void)?
    
    init() {
        loadBudgetsLocally()
    }
    
    func fetchBudgets() {
        // This method now just triggers the didSet of budgets
        // which will call budgetsDidChange
        let budgets1 = budgets
        budgets = budgets1
    }
    
    func addBudget(_ budget: Budget) {
        budgets.insert(budget, at: 0)
    }
    
    func deductFromBudget(amount: Double, budgetId: Int) {
        if let index = budgets.firstIndex(where: { $0.id == budgetId }) {
            var updatedBudget = budgets[index]
            updatedBudget.remainingAmount -= amount
            budgets[index] = updatedBudget
        }
    }
    
    private func saveBudgetsLocally() {
        do {
            let data = try JSONEncoder().encode(budgets)
            UserDefaults.standard.set(data, forKey: "savedBudgets")
        } catch {
            print("Failed to save budgets: \(error)")
        }
    }
    
    private func loadBudgetsLocally() {
        if let data = UserDefaults.standard.data(forKey: "savedBudgets") {
            do {
                budgets = try JSONDecoder().decode([Budget].self, from: data)
            } catch {
                print("Failed to load budgets: \(error)")
            }
        }
    }
}
