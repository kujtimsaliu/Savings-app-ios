//
//  IncomeViewController.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//

import UIKit

class IncomeViewController: OnboardingViewController {
    let incomeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Monthly income after taxes"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "What's your monthly income after taxes?"
        progressView.progress = 0.6
        setupIncomeTextField()
    }
    
    func setupIncomeTextField() {
        view.addSubview(incomeTextField)
        incomeTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            incomeTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            incomeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            incomeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            incomeTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
