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
        
        if let user = UserDefaults.standard.getUser() {
            print("User already signed in: \(user.name)")
            self.view.backgroundColor = .green
        }
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
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] signInResult, error in
            guard let self = self, let result = signInResult else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let googleUser = result.user
            
            // Save user data locally first
            UserDefaults.standard.setUser(
                id: -1, // Temporary ID, will be updated after backend sync
                googleId: googleUser.userID ?? "",
                email: googleUser.profile?.email ?? "",
                name: googleUser.profile?.name ?? "",
                givenName: googleUser.profile?.givenName ?? "",
                familyName: googleUser.profile?.familyName ?? "",
                pictureUrl: googleUser.profile?.imageURL(withDimension: 100)?.absoluteString ?? "",
                income: nil
            )
            
            // Then communicate with backend
            UserService.shared.createOrFetchUser(googleUser: googleUser) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let user):
                        print("User data synced with backend: \(user.name)")
                        // Update local storage with any additional info from backend
                        UserDefaults.standard.setUser(
                            id: user.id,
                            googleId: user.googleId,
                            email: user.email,
                            name: user.name,
                            givenName: user.givenName,
                            familyName: user.familyName,
                            pictureUrl: user.pictureUrl,
                            income: user.income
                        )
                        self.view.backgroundColor = .green
                    case .failure(let error):
                        print("Failed to sync with backend: \(error.localizedDescription)")
                        // Keep the locally saved data
                        self.view.backgroundColor = .orange // Indicate partial success
                    }
                }
            }
        }
    }
}
