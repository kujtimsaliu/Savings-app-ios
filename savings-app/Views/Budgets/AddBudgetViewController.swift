//
//  AddBudgetViewController.swift
//  savings-app
//
//  Created by Kujtim Saliu on 28.8.24.
//

import UIKit

protocol AddBudgetViewControllerDelegate: AnyObject {
    func didAddBudget(_ budget: Budget)
}

class AddBudgetViewController: UIViewController {
    weak var delegate: AddBudgetViewControllerDelegate?
    
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Amount"
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
        
        view.addSubview(amountTextField)
        view.addSubview(frequencySegmentedControl)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            amountTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            amountTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            frequencySegmentedControl.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 20),
            frequencySegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            frequencySegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            addButton.topAnchor.constraint(equalTo: frequencySegmentedControl.bottomAnchor, constant: 20),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    @objc private func addButtonTapped() {
        guard let amountString = amountTextField.text,
              let amount = Double(amountString) else {
            // Show error
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
        
        let newBudget = Budget(id: 0, amount: amount, frequency: frequency, startDate: Date(), createdAt: Date(), ownerId: 0)
        delegate?.didAddBudget(newBudget)
        dismiss(animated: true)
    }
}


