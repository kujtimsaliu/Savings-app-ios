//
//  SetupCompleteViewController.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//

import UIKit

class SetupCompleteViewController: OnboardingViewController, SignUpViewControllerDelegate {

    lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Setup complete!\nYou're almost ready to go."
        progressView.progress = 1.0
        setupSignUpButton()
    }
    
    func setupSignUpButton() {
        view.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40)
        ])
    }
    
    @objc func signUpTapped() {
//        delegate?.didFinishOnboarding()
        let signUpVC = SignUpViewController()
        signUpVC.delegate = self
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    func didFinishSignUp() {
        delegate?.didFinishOnboarding()
    }
}
