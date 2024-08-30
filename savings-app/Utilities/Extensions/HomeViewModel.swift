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
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        default: return "Good Evening"
        }
    }
    
    var totalBalance: Double {
        // Implement logic to calculate total balance
        return 5000.0 // Placeholder value
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
    
    func fetchData() {
        // Fetch expenses and budgets from your data source (e.g., Core Data, API, etc.)
        // For this example, we'll use dummy data
        expenses = [
            Expense(id: "1", amount: 50.0, category: "Food", description: "Groceries", date: Date(), paymentMethod: "Credit Card", isRecurring: false, recurringFrequency: nil, hasReminder: false),
            Expense(id: "2", amount: 130.0, category: "Transport", description: "Gas", date: Date().addingTimeInterval(-86400), paymentMethod: "Debit Card", isRecurring: false, recurringFrequency: nil, hasReminder: false),
            Expense(id: "3", amount: 100.0, category: "Entertainment", description: "Movie tickets", date: Date().addingTimeInterval(-172800), paymentMethod: "Cash", isRecurring: false, recurringFrequency: nil, hasReminder: false),
            Expense(id: "4", amount: 30.0, category: "Entertainment", description: "Movie tickets", date: Date().addingTimeInterval(-172800), paymentMethod: "Cash", isRecurring: false, recurringFrequency: nil, hasReminder: false)
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
