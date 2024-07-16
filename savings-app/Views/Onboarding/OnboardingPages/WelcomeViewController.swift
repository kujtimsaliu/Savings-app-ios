//
//  WelcomeViewController.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//

import UIKit

class WelcomeViewController: OnboardingViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = """
                            Welcome to 'ExpenseTrackerApp[Name]
                            Ready to take control of your finances?
                        """
        progressView.progress = 0.0
    }
}
