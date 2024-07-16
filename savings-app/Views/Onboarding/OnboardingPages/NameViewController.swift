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
        tf.placeholder = "Enter your name"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = """
                          Let's start wiht your name. 
                          What should we call you
                          """
        progressView.progress = 0.2
        setupNameTextField()
    }
    
    func setupNameTextField() {
        view.addSubview(nameTextField)
        nameTextField.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, topConstant: 40, leftConstant: 40, rightConstant: 40, heightConstant: 44)
    }
    
}
