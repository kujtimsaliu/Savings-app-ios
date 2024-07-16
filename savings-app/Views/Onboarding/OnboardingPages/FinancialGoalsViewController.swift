//
//  FinancialGoalsViewController.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//

import UIKit

class FinancialGoalsViewController: OnboardingViewController {
    lazy var goalsTextView: UITextView = {
        let tf = UITextView()
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 5
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "What are you main financial goals?"
        progressView.progress = 0.4
        
        setupGoalsTextView()
    }
    
    func setupGoalsTextView(){
        view.addSubview(goalsTextView)
        goalsTextView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, topConstant: 40, leftConstant: 40, rightConstant: 40, heightConstant: 75)
    }
}
