//
//  HomeViewController.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//

import UIKit

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let tokenManager = TokenManager()
        print("jaja\(String(describing: tokenManager.getAccessToken()))")
        print(tokenManager.getRefreshToken() ?? "tapa")
        view.backgroundColor = .systemBackground
        title = "Home"
    }
}
