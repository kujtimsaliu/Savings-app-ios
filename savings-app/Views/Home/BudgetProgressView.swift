//
//  BudgetProgressView.swift
//  savings-app
//
//  Created by Kujtim Saliu on 31.8.24.
//

import UIKit

class BudgetProgressView: UIView {
    private let progressView = UIProgressView(progressViewStyle: .bar)
    private let labelStack = UIStackView()
    private let budgetLabel = UILabel()
    private let remainingLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [progressView, labelStack].forEach { addSubview($0) }
        [budgetLabel, remainingLabel].forEach { labelStack.addArrangedSubview($0) }
        
        progressView.progressTintColor = .systemBlue
        labelStack.axis = .horizontal
        labelStack.distribution = .equalSpacing
        
        [budgetLabel, remainingLabel].forEach { $0.font = UIFont.systemFont(ofSize: 14) }
        
        [progressView, labelStack].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 8),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -8),
            
            labelStack.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 8),
            labelStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            labelStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            labelStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        
        backgroundColor = .systemBackground
        
        progressView.layer.cornerRadius = 4
        progressView.clipsToBounds = true
    }
    
    func configure(with progress: (spent: Double, total: Double)) {
        progressView.progress = Float(progress.spent / progress.total)
        budgetLabel.text = "Budget: $\(String(format: "%.2f", progress.total))"
        remainingLabel.text = "Remaining: $\(String(format: "%.2f", progress.total - progress.spent))"
    }
}
