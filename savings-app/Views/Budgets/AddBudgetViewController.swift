//
//  AddBudgetViewController.swift
//  savings-app
//
//  Created by Kujtim Saliu on 28.8.24.
//

import UIKit
import UserNotifications

protocol AddBudgetViewControllerDelegate: AnyObject {
    func didAddBudget(_ budget: Budget)
}

class AddBudgetViewController: UIViewController {
    weak var delegate: AddBudgetViewControllerDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add a new budget!"
        label.textAlignment = .center
        label.add(width: view.bounds.width, height: 40)
        return label
    }()
    
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Budget Name"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Amount"
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let savingsGoalTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Savings Goal"
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let frequencySegmentedControl: UISegmentedControl = {
        let items = ["Daily", "Monthly", "Once"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let notifySwitch: UISwitch = {
        let switch_ = UISwitch()
        switch_.translatesAutoresizingMaskIntoConstraints = false
        return switch_
    }()
    
    private let notifyLabel: UILabel = {
        let label = UILabel()
        label.text = "Notify when close to limit"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Budget", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(amountTextField)
        view.addSubview(savingsGoalTextField)
        view.addSubview(frequencySegmentedControl)
        view.addSubview(notifySwitch)
        view.addSubview(notifyLabel)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            
            
            amountTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            amountTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            savingsGoalTextField.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 20),
            savingsGoalTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            savingsGoalTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            frequencySegmentedControl.topAnchor.constraint(equalTo: savingsGoalTextField.bottomAnchor, constant: 20),
            frequencySegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            frequencySegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            notifySwitch.topAnchor.constraint(equalTo: frequencySegmentedControl.bottomAnchor, constant: 20),
            notifySwitch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            notifyLabel.centerYAnchor.constraint(equalTo: notifySwitch.centerYAnchor),
            notifyLabel.leadingAnchor.constraint(equalTo: notifySwitch.trailingAnchor, constant: 10),
            
            addButton.topAnchor.constraint(equalTo: notifySwitch.bottomAnchor, constant: 20),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    @objc private func addButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(title: "Error", message: "Please enter a budget name.")
            return
        }
        
        guard let amountString = amountTextField.text, let amount = Double(amountString), amount > 0 else {
            showAlert(title: "Error", message: "Please enter a valid amount.")
            return
        }
        
        guard let savingsGoalString = savingsGoalTextField.text, let savingsGoal = Double(savingsGoalString), savingsGoal >= 0 else {
            showAlert(title: "Error", message: "Please enter a valid savings goal.")
            return
        }

        let frequencyIndex = frequencySegmentedControl.selectedSegmentIndex
        let frequency: BudgetFrequency
        switch frequencyIndex {
        case 0:
            frequency = .daily
        case 1:
            frequency = .monthly
        case 2:
            frequency = .once
        default:
            frequency = .monthly
        }
        
        let newBudget = Budget(id: Int.random(in: 100...1000),
                               name: name,
                               amount: amount,
                               frequency: frequency,
                               startDate: Date(),
                               createdAt: Date(),
                               ownerId: 1,
                               remainingAmount: amount,
                               savingsGoal: savingsGoal,
                               notifyWhenClose: notifySwitch.isOn)

        showConfirmationDialog(for: newBudget)
    }
    
    private func showConfirmationDialog(for budget: Budget) {
        let message = """
        Budget Name: \(budget.name)
        Amount: \(budget.amount)
        Savings Goal: \(budget.savingsGoal)
        Frequency: \(budget.frequency.rawValue.capitalized)
        Notify: \(budget.notifyWhenClose ? "Yes" : "No")
        """
        
        let alertController = UIAlertController(title: "Confirm Budget", message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
            self?.delegate?.didAddBudget(budget)
            
            if budget.notifyWhenClose {
                self?.scheduleNotification(for: budget)
            }
            
            self?.dismiss(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func scheduleNotification(for budget: Budget) {
        let content = UNMutableNotificationContent()
        content.title = "Budget Alert"
        content.body = "You're close to spending your budget for \(budget.name)"
        content.sound = .default
        
        // Calculate when to send the notification (e.g., when 80% of the budget is spent)
        let triggerAmount = budget.amount * 0.8
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false) // For testing, set to 1 minute
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
}
