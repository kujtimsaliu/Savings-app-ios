//
//  FinancialGoalsViewController.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//

import UIKit

class FinancialGoalsViewController: OnboardingViewController {
    lazy var goalsTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 17)
        tv.layer.borderColor = UIColor.systemGray4.cgColor
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = 8
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "What are your main financial goals?"
        subtitleLabel.text = "We'll help you achieve them"
        progressView.progress = 0.4
        setupGoalsTextView()
    }

    func setupGoalsTextView() {
        view.addSubview(goalsTextView)
        goalsTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            goalsTextView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            goalsTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            goalsTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            goalsTextView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    override func saveData() {
        UserDefaults.standard.set(goalsTextView.text, forKey: "financialGoals")
    }
}
