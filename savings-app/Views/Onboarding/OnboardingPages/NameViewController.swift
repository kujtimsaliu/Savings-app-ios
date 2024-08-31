//
//  NameViewController.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//

import UIKit

class NameViewController: OnboardingViewController, UITextFieldDelegate {
    lazy var nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Your Name"
        tf.borderStyle = .roundedRect
        tf.returnKeyType = .continue
        tf.font = UIFont.systemFont(ofSize: 17)
        tf.delegate = self
        return tf
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "What's your name?"
        subtitleLabel.text = "Let's personalize your experience"
        progressView.progress = 0.2
        setupNameTextField()
        setupTapGesture()
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @objc override func nextButtonTapped() {
        
        if let name = nameTextField.text, !name.isEmpty {
            saveData()
            delegate?.moveToNextScreen(self)
        } else {
            let alert = UIAlertController(title: "Error", message: "Please make sure you have entered your name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    override func saveData() {
        UserDefaults.standard.set(nameTextField.text, forKey: "userName")
    }
}
