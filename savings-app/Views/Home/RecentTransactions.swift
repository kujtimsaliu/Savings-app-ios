//
//  RecentTransactions.swift
//  savings-app
//
//  Created by Kujtim Saliu on 31.8.24.
//

import UIKit

class RecentTransactionsView: UIView {
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [titleLabel, stackView].forEach { addSubview($0) }
        
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.text = "Recent Transactions"
        
        stackView.axis = .vertical
        stackView.spacing = 8
        
        [titleLabel, stackView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 6),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -6),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        
        backgroundColor = .systemBackground
    }
    
    func configure(with transactions: [Expense]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        transactions.prefix(5).forEach { expense in
            let transactionView = TransactionView()
            transactionView.configure(with: expense)
            stackView.addArrangedSubview(transactionView)
        }
    }
}

