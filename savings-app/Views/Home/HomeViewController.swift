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
        
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
    }
}
