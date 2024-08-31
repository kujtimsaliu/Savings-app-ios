//
//  BalanceView.swift
//  savings-app
//
//  Created by Kujtim Saliu on 31.8.24.
//

 import UIKit

class BalanceView: UIView {
    private let balanceLabel = UILabel()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [balanceLabel, titleLabel].forEach { addSubview($0) }
        
        balanceLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        balanceLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .white
        
        [balanceLabel, titleLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            balanceLabel.topAnchor.constraint(equalTo: topAnchor),
            balanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            balanceLabel.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        
//        backgroundColor = .systemBackground
    }
    
    func configure(with balance: Double) {
        balanceLabel.text = String(format: "$%.2f", balance)
        titleLabel.text = "Total Balance"
    }
}
