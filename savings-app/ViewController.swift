//
//  ViewController.swift
//  savings-app
//
//  Created by Kujtim Saliu on 2.7.24.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setupGoogleSignInButton()
    }
    
    func setupGoogleSignInButton() {
        let signInButton = GIDSignInButton()
        signInButton.style = .standard
        signInButton.frame = CGRect(x: 0, y: 0, width: 230, height: 40)
        signInButton.center = view.center
        view.addSubview(signInButton)
        
        signInButton.addTarget(self, action: #selector(googleSignInTapped), for: .touchUpInside)
    }
    
    @objc func googleSignInTapped() {
        GoogleSignInManager.shared.signIn(presenting: self) { result in
            switch result {
            case .success(let idToken):
                self.authenticateWithBackend(idToken: idToken)
            case .failure(let error):
                print("Google Sign-In failed: \(error.localizedDescription)")
            }
        }
    }
    
    func authenticateWithBackend(idToken: String) {
        UserService.shared.googleAuth(idToken: idToken) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    print("Authenticated user: \(user.name)")
                    self.view.backgroundColor = .green
                case .failure(let error):
                    print("Backend authentication failed: \(error)")
                    if let decodingError = error as? DecodingError {
                        switch decodingError {
                            case .dataCorrupted(let context):
                            print(context)
                        case .keyNotFound(let key, let context):
                            print("Key '\(key)' not found:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        case .valueNotFound(let value, let context):
                            print("Value '\(value)' not found:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        case .typeMismatch(let type, let context):
                            print("Type '\(type)' mismatch:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        @unknown default:
                            print("Unknown decoding error")
                        }
                    }
                    self.view.backgroundColor = .red
                }
            }
        }
    }
}

//
//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .red
//        login()
//    }
//    
//    func login() {
//        let username = "ks@gmail.com"
//        let password = "string123"
//        
//        
//        UserService.shared.login(username: username, password: password) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let token):
//                    print("Login successful! Token: \(token)")
//                    self.view.backgroundColor = .green
//                case .failure(let error):
//                    print("Login failed: \(error.localizedDescription)")
//                    if let error = error as NSError? {
//                        print("Error domain: \(error.domain), code: \(error.code)")
//                        if let responseString = error.userInfo["responseString"] as? String {
//                            print("Response: \(responseString)")
//                        }
//                    }
//                    self.view.backgroundColor = .red
//                }
//            }
//        }
//    }
//}
