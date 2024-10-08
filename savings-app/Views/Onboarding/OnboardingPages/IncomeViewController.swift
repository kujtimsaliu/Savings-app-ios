//
//  IncomeViewController.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//

import UIKit

class IncomeViewController: OnboardingViewController, UITextFieldDelegate {
    lazy var incomeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Monthly Income"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .decimalPad
        tf.font = UIFont.systemFont(ofSize: 17)
        tf.returnKeyType = .done
        tf.delegate = self
        return tf
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "What's your monthly income?"
        subtitleLabel.text = "This helps us tailor our advice to your situation"
        progressView.progress = 0.6
        setupIncomeTextField()
        setupTapGesture()
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.endEditing(true)
    }

    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc override func nextButtonTapped() {
        if let income = incomeTextField.text, !income.isEmpty {
            saveData()
            delegate?.moveToNextScreen(self)
        } else {
            let alert = UIAlertController(title: "Error", message: "Please make sure to fill the form!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    override func saveData() {
        if let incomeText = incomeTextField.text, let income = Double(incomeText) {
            UserDefaults.standard.set(income, forKey: "monthlyIncome")
        }
    }
}
