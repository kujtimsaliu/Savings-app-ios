//
//  SignUpViewController.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//

import UIKit
import GoogleSignIn

protocol SignUpViewControllerDelegate: AnyObject {
    func didFinishSignUp()
}

class SignUpViewController: UIViewController {
    weak var delegate: SignUpViewControllerDelegate?
    private let viewModel: SignUpViewModel

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create Your Account"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()

    private let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirm Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()

    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        return button
    }()

    private let googleSignInButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.style = .standard
        return button
    }()

    init(viewModel: SignUpViewModel = SignUpViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGoogleSignIn()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        let stackView = UIStackView(arrangedSubviews: [titleLabel, emailTextField, passwordTextField, confirmPasswordTextField, signUpButton, googleSignInButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.setCustomSpacing(40, after: titleLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),

            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            googleSignInButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }

    private func setupGoogleSignIn() {
        googleSignInButton.addTarget(self, action: #selector(googleSignInButtonTapped), for: .touchUpInside)
    }

    @objc private func signUpButtonTapped() {
        viewModel.email = emailTextField.text ?? ""
        viewModel.password = passwordTextField.text ?? ""
        viewModel.confirmPassword = confirmPasswordTextField.text ?? ""

        viewModel.signUp { [weak self] result in
            self?.handleAuthResult(result)
        }
    }

    @objc private func googleSignInButtonTapped() {
        viewModel.signInWithGoogle(presenting: self) { [weak self] result in
            self?.handleAuthResult(result)
        }
    }

    private func handleAuthResult(_ result: Result<Void, Error>) {
        DispatchQueue.main.async {
            switch result {
            case .success:
                self.delegate?.didFinishSignUp()
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}



//==============================

//
//class SignUpViewController: UIViewController {
//    weak var delegate: SignUpViewControllerDelegate?
//    private let viewModel: SignUpViewModel
//
//    private let emailTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Email"
//        textField.borderStyle = .roundedRect
//        textField.keyboardType = .emailAddress
//        return textField
//    }()
//
//    private let passwordTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Password"
//        textField.borderStyle = .roundedRect
//        textField.isSecureTextEntry = true
//        return textField
//    }()
//
//    private let confirmPasswordTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Confirm Password"
//        textField.borderStyle = .roundedRect
//        textField.isSecureTextEntry = true
//        return textField
//    }()
//
//    private let signUpButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Sign Up", for: .normal)
//        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
//        return button
//    }()
//
//    init(viewModel: SignUpViewModel = SignUpViewModel()) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//    }
//
//    private func setupUI() {
//        view.backgroundColor = .systemBackground
//
//        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, confirmPasswordTextField, signUpButton])
//        stackView.axis = .vertical
//        stackView.spacing = 20
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(stackView)
//
//        NSLayoutConstraint.activate([
//            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
//            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
//        ])
//    }
//
//    @objc private func signUpButtonTapped() {
//        viewModel.email = emailTextField.text ?? ""
//        viewModel.password = passwordTextField.text ?? ""
//        viewModel.confirmPassword = confirmPasswordTextField.text ?? ""
//
//        viewModel.signUp { [weak self] success, error in
//            guard let self = self else { return }
//
//            if success {
//                self.delegate?.didFinishSignUp()
//            } else {
//                let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//            }
//        }
//    }
//}
//
//



