//
//  SetupCompleteViewController.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//

import UIKit

class SetupCompleteViewController: OnboardingViewController, SignUpViewControllerDelegate {
    private let completionImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        imageView.tintColor = .systemGreen
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy var getStartedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get Started", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(getStartedTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Setup Complete!"
        subtitleLabel.text = "You're all set to start your financial journey"
        progressView.progress = 1.0
        setupCompletionImageView()
        setupGetStartedButton()
    }

    private func setupCompletionImageView() {
        view.addSubview(completionImageView)
        completionImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            completionImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            completionImageView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            completionImageView.widthAnchor.constraint(equalToConstant: 120),
            completionImageView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }

    private func setupGetStartedButton() {
        view.addSubview(getStartedButton)
        getStartedButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            getStartedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getStartedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            getStartedButton.widthAnchor.constraint(equalToConstant: 200),
            getStartedButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func getStartedTapped() {
        let signUpVC = SignUpViewController()
        signUpVC.delegate = self
        navigationController?.pushViewController(signUpVC, animated: true)
    }

    func didFinishSignUp() {
        delegate?.didFinishOnboarding()
    }
}
