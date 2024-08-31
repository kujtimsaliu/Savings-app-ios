//
//  ExpenseCategoriesViewController.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//
import UIKit

class ExpenseCategoriesViewController: OnboardingViewController {
    // Updated and expanded list of categories with icons
    let categories = [
        ("Housing", "house.fill"),
        ("Utilities", "bolt.fill"),
        ("Groceries", "cart.fill"),
        ("Transportation", "car.fill"),
        ("Entertainment", "gamecontroller.fill"),
        ("Dining Out", "fork.knife"),
        ("Healthcare", "heart.fill"),
        ("Insurance", "shield.fill"),
        ("Subscriptions", "tv.fill"),
        ("Savings", "money.fill"),
        ("Travel", "airplane"),
        ("Education", "book.fill"),
        ("Clothing", "tshirt.fill")
    ]
    
    var selectedCategories: Set<String> = []

    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    lazy var categoriesStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 15
        sv.distribution = .fillEqually
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Select Your Expense Categories"
        subtitleLabel.text = "This helps us customize your budgeting experience"
        progressView.progress = 0.8
        setupScrollView()
        setupCategoriesStackView()
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            scrollView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -30)
        ])
        
        scrollView.addSubview(categoriesStackView)
        categoriesStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoriesStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            categoriesStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            categoriesStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            categoriesStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            categoriesStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    func setupCategoriesStackView() {
        for (category, iconName) in categories {
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            button.setImage(UIImage(systemName: iconName), for: .normal)
            button.contentHorizontalAlignment = .center
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
            button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
            button.setTitleColor(.label, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            button.backgroundColor = .systemGray6
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.systemGray4.cgColor
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = 0.1
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
            button.layer.shadowRadius = 4
            button.addTarget(self, action: #selector(categoryToggled(_:)), for: .touchUpInside)
            button.heightAnchor.constraint(equalToConstant: 60).isActive = true
            categoriesStackView.addArrangedSubview(button)
        }
    }
    
    @objc func categoryToggled(_ sender: UIButton) {
        sender.isSelected.toggle()
        if let category = sender.title(for: .normal) {
            if sender.isSelected {
                selectedCategories.insert(category)
                sender.backgroundColor = .systemBlue
                sender.setTitleColor(.white, for: .normal)
                sender.layer.borderColor = UIColor.systemBlue.cgColor
            } else {
                selectedCategories.remove(category)
                sender.backgroundColor = .systemGray6
                sender.setTitleColor(.label, for: .normal)
                sender.layer.borderColor = UIColor.systemGray4.cgColor
                sender.tintColor = .systemBlue
            }
        }
    }
    
    override func saveData() {
        UserDefaults.standard.set(Array(selectedCategories), forKey: "selectedExpenseCategories")
    }
}
