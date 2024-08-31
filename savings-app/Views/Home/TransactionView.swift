//
//  TransactionView.swift
//  savings-app
//
//  Created by Kujtim Saliu on 31.8.24.
//

import UIKit

class TransactionView: UIView {
    private let categoryLabel = UILabel()
    private let amountLabel = UILabel()
    private let dateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [categoryLabel, amountLabel, dateLabel].forEach { addSubview($0) }
        
        categoryLabel.font = UIFont.systemFont(ofSize: 16)
        amountLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .secondaryLabel
        
        [categoryLabel, amountLabel, dateLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 5),
            
            amountLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            dateLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 5),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
        
        layer.cornerRadius = 10
        backgroundColor = .systemGray6
    }
    
    func configure(with expense: Expense) {
        categoryLabel.text = expense.category
        amountLabel.text = String(format: "$%.2f", expense.amount)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        dateLabel.text = dateFormatter.string(from: expense.date)
    }
}
