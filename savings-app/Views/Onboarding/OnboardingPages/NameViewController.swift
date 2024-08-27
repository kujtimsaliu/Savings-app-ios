//
//  NameViewController.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//

import UIKit

class NameViewController: OnboardingViewController {
    lazy var nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Your Name"
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 17)
        return tf
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "What's your name?"
        subtitleLabel.text = "Let's personalize your experience"
        progressView.progress = 0.2
        setupNameTextField()
    }

    func setupNameTextField() {
        view.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            nameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    override func saveData() {
        UserDefaults.standard.set(nameTextField.text, forKey: "userName")
    }
}
