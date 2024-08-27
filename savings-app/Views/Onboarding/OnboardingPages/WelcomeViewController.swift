//
//  WelcomeViewController.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//

import UIKit

class WelcomeViewController: OnboardingViewController {
    private let iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "leaf.fill"))
        imageView.tintColor = .systemGreen
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Welcome to FinanceApp"
        subtitleLabel.text = "Take control of your finances and achieve your financial goals."
        progressView.progress = 0.0
        setupIconImageView()
    }

    private func setupIconImageView() {
        view.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            iconImageView.widthAnchor.constraint(equalToConstant: 120),
            iconImageView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
}
