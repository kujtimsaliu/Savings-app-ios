//
//  ExpenseCategoriesViewController.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//
import UIKit

class ExpenseCategoriesViewController: OnboardingViewController {
    let categoriesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let categories = ["Housing", "Utilities", "Groceries", "Transportation", "Entertainment"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Which of these expense categories apply to you?"
        progressView.progress = 0.8
        setupCategoriesStackView()
    }
    
    func setupCategoriesStackView() {
        view.addSubview(categoriesStackView)
        categoriesStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoriesStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            categoriesStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            categoriesStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        for category in categories {
            let checkbox = UIButton(type: .system)
            checkbox.setTitle(category, for: .normal)
            checkbox.contentHorizontalAlignment = .left
            checkbox.setImage(UIImage(systemName: "square"), for: .normal)
            checkbox.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
            checkbox.addTarget(self, action: #selector(categoryToggled(_:)), for: .touchUpInside)
            categoriesStackView.addArrangedSubview(checkbox)
        }
    }
    
    @objc func categoryToggled(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
}

