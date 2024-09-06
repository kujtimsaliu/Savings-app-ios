//
//  ExpensesViewModel.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//

import UIKit

class ExpensesViewModel {
    private(set) var expenses: [Expense] = [] {
        didSet {
            saveExpensesLocally()
            expensesDidChange?()
        }
    }
    
    var expensesDidChange: (() -> Void)?
    
    init() {
        loadExpensesLocally()
    }
    
    func fetchExpenses() {
        if expenses.isEmpty {
            let sampleExpenses = [
                Expense(id: UUID().uuidString, amount: 50.0, category: "Food", description: "Groceries", date: Date().addingTimeInterval(-86400 * 6), paymentMethod: "Credit Card", isRecurring: false, recurringFrequency: nil, hasReminder: false),
                Expense(id: UUID().uuidString, amount: 30.0, category: "Transport", description: "Gas", date: Date().addingTimeInterval(-86400 * 5), paymentMethod: "Debit Card", isRecurring: false, recurringFrequency: nil, hasReminder: false),
                Expense(id: UUID().uuidString, amount: 100.0, category: "Entertainment", description: "Concert tickets", date: Date().addingTimeInterval(-86400 * 3), paymentMethod: "Credit Card", isRecurring: false, recurringFrequency: nil, hasReminder: false),
                Expense(id: UUID().uuidString, amount: 20.0, category: "Food", description: "Lunch", date: Date().addingTimeInterval(-86400 * 2), paymentMethod: "Cash", isRecurring: false, recurringFrequency: nil, hasReminder: false),
                Expense(id: UUID().uuidString, amount: 80.0, category: "Utilities", description: "Electricity bill", date: Date().addingTimeInterval(-86400), paymentMethod: "Bank Transfer", isRecurring: true, recurringFrequency: "Monthly", hasReminder: true)
            ]
            expenses = sampleExpenses
        }
        
        // This will trigger the didSet of expenses, which will call expensesDidChange
        let expenses1 = expenses
        expenses = expenses1
    }
    
    func addExpense(_ expense: Expense) {
        expenses.insert(expense, at: 0)
    }
    
    private func saveExpensesLocally() {
        do {
            let data = try JSONEncoder().encode(expenses)
            UserDefaults.standard.set(data, forKey: "savedExpenses")
        } catch {
            print("Failed to save expenses: \(error)")
        }
    }

    private func loadExpensesLocally() {
        if let data = UserDefaults.standard.data(forKey: "savedExpenses") {
            do {
                expenses = try JSONDecoder().decode([Expense].self, from: data)
            } catch {
                print("Failed to load expenses: \(error)")
            }
        }
    }

    func upcomingBills() -> [Expense] {
        let currentDate = Date()
        let calendar = Calendar.current
        let oneDayLater = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        
        return expenses.filter { expense in
            expense.isRecurring
        }
    }
}
