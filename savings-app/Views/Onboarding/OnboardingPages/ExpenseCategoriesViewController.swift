//
//  ExpenseCategoriesViewController.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//
import UIKit

class ExpenseCategoriesViewController: OnboardingViewController {
    let categories = ["Housing", "Utilities", "Groceries", "Transportation", "Entertainment"]
    var selectedCategories: Set<String> = []

    lazy var categoriesStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 15
        sv.distribution = .fillEqually
        return sv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Select your expense categories"
        subtitleLabel.text = "This helps us customize your budgeting experience"
        progressView.progress = 0.8
        setupCategoriesStackView()
    }

    func setupCategoriesStackView() {
        view.addSubview(categoriesStackView)
        categoriesStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoriesStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            categoriesStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            categoriesStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])

        for category in categories {
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            button.contentHorizontalAlignment = .left
            button.setImage(UIImage(systemName: "square"), for: .normal)
            button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
            button.tintColor = .systemBlue
            button.addTarget(self, action: #selector(categoryToggled(_:)), for: .touchUpInside)
            categoriesStackView.addArrangedSubview(button)
        }
    }

    @objc func categoryToggled(_ sender: UIButton) {
        sender.isSelected.toggle()
        if let category = sender.title(for: .normal) {
            if sender.isSelected {
                selectedCategories.insert(category)
            } else {
                selectedCategories.remove(category)
            }
        }
    }

    override func saveData() {
        UserDefaults.standard.set(Array(selectedCategories), forKey: "selectedExpenseCategories")
    }
}
