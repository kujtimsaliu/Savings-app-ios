//
//  HomeViewModel.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//

import UIKit

class HomeViewModel {
    private var expenses: [Expense] = []
    private var budgets: [Budget] = []
    
    var updateUI: (() -> Void)?
    
    var greeting: String {
        var username = ""
        if let user = UserDefaults.standard.getUser() {
            username = user.givenName
        }
            
            let hour = Calendar.current.component(.hour, from: Date())
            switch hour {
            case 0..<12: return "Good Morning, \(username) "
            case 12..<17: return "Good Afternoon, \(username)"
            default: return "Good Evening, \(username) "
            }
    }
    
    var totalBalance: Double {
        if let data = UserDefaults.standard.data(forKey: "savedBudgets") {
            do {
                budgets = try JSONDecoder().decode([Budget].self, from: data)
            } catch {
                print("Failed to load budgets: \(error)")
            }
        }
        var totalBudget = 0.0
        budgets.forEach { budget in
            totalBudget += budget.amount
        }
        return totalBudget
    }
    
    var expenseSummary: (total: Double, average: Double) {
        let total = expenses.reduce(0) { $0 + $1.amount }
        let average = total / Double(max(1, expenses.count))
        return (total, average)
    }
    
    var budgetProgress: (spent: Double, total: Double) {
        let spent = expenses.reduce(0) { $0 + $1.amount }
        let total = budgets.reduce(0) { $0 + $1.amount }
        return (spent, total)
    }
    
    var recentTransactions: [Expense] {
        return Array(expenses.prefix(5))
    }
    
    var monthlySpending: [Double] {
        // Calculate monthly spending for the last 6 months
        let calendar = Calendar.current
        let now = Date()
        return (0..<6).map { monthsAgo in
            let startOfMonth = calendar.date(byAdding: .month, value: -monthsAgo, to: .now)!
            let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
            return expenses.filter { $0.date >= startOfMonth && $0.date <= endOfMonth }
                .reduce(0) { $0 + $1.amount }
        }.reversed()
    }
    
    func addBudget(_ budget: Budget) {
        budgets.append(budget)
        saveBudgets()
        updateUI?()
    }
    
    private func saveBudgets() {
        do {
            let data = try JSONEncoder().encode(budgets)
            UserDefaults.standard.set(data, forKey: "savedBudgets")
        } catch {
            print("Failed to save budgets: \(error)")
        }
    }

    
    func fetchData() {
        // Fetch expenses and budgets from your data source (e.g., Core Data, API, etc.)
        // For this example, we'll use dummy data
        expenses = [
            Expense(id: "1", amount: 50.0, category: "Food", description: "Groceries", date: Date(), paymentMethod: "Credit Card", isRecurring: false, recurringFrequency: nil, hasReminder: false),
            Expense(id: "2", amount: 130.0, category: "Transport", description: "Gas", date: Date().addingTimeInterval(-86400), paymentMethod: "Debit Card", isRecurring: false, recurringFrequency: nil, hasReminder: false),
            Expense(id: "3", amount: 100.0, category: "Entertainment", description: "Movie tickets", date: Date().addingTimeInterval(-172800), paymentMethod: "Cash", isRecurring: false, recurringFrequency: nil, hasReminder: false)
        ]
        
        budgets = [
            Budget(id: 1, name: "Monthly Budget", amount: 2000.0, frequency: .monthly, startDate: Date(), createdAt: Date(), ownerId: 1, remainingAmount: 1820.0, savingsGoal: 500.0, notifyWhenClose: true)
        ]
        
        updateUI?()
    }
    
    func addExpense(_ expense: Expense) {
        expenses.insert(expense, at: 0)
        updateUI?()
    }
}
