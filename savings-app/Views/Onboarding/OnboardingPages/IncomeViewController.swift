//
//  IncomeViewController.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//

import UIKit

class IncomeViewController: OnboardingViewController {
    lazy var incomeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Monthly Income"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .decimalPad
        tf.font = UIFont.systemFont(ofSize: 17)
        return tf
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "What's your monthly income?"
        subtitleLabel.text = "This helps us tailor our advice to your situation"
        progressView.progress = 0.6
        setupIncomeTextField()
    }

    func setupIncomeTextField() {
        view.addSubview(incomeTextField)
        incomeTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            incomeTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            incomeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            incomeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            incomeTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    override func saveData() {
        if let incomeText = incomeTextField.text, let income = Double(incomeText) {
            UserDefaults.standard.set(income, forKey: "monthlyIncome")
        }
    }
}
