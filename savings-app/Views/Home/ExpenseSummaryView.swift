//
//  ExpenseSummaryView.swift
//  savings-app
//
//  Created by Kujtim Saliu on 31.8.24.
//

import UIKit

class ExpenseSummaryView: UIView {
    private let totalExpensesLabel = UILabel()
    private let averageDailyExpenseLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [totalExpensesLabel, averageDailyExpenseLabel].forEach { addSubview($0) }
        
        [totalExpensesLabel, averageDailyExpenseLabel].forEach {
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            totalExpensesLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            totalExpensesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            averageDailyExpenseLabel.topAnchor.constraint(equalTo: totalExpensesLabel.bottomAnchor, constant: 8),
            averageDailyExpenseLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
//            averageDailyExpenseLabel.bottomAnchor.constraint(equalTo: bottomAnchor,constant: 10)
        ])
        
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        
        backgroundColor = .systemBackground
    }
    
    func configure(with summary: (total: Double, average: Double)) {
        totalExpensesLabel.text = "Total Expenses: $\(String(format: "%.2f", summary.total))"
        averageDailyExpenseLabel.text = "Avg. Daily: $\(String(format: "%.2f", summary.average))"
    }
}
