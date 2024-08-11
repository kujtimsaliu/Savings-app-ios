//
//  SignUpViewModel.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//

import UIKit
import GoogleSignIn

class SignUpViewModel {
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    
    private let userService: UserService
    
    init(userService: UserService = UserService.shared) {
        self.userService = userService
    }
    
    func signUp(completion: @escaping (Result<Void, Error>) -> Void) {
        // Validate input
        guard !email.isEmpty, !password.isEmpty, password == confirmPassword else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid input"])))
            return
        }
        
        // Call API to sign up user
        userService.signUp(email: email, password: password) { result in
            switch result {
            case .success(let user):
                UserDefaults.standard.setUser(id: user.id ?? "123",
                                              googleId: user.googleId,
                                              email: user.email,
                                              name: user.name,
                                              givenName: user.givenName,
                                              familyName: user.familyName,
                                              pictureUrl: user.pictureUrl,
                                              income: user.income)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func signInWithGoogle(presenting viewController: UIViewController, completion: @escaping (Result<Void, Error>) -> Void) {
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { [weak self] signInResult, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            
            guard let result = signInResult else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No sign-in result"])))
                return
            }
            
            let user = result.user
            guard let idToken = user.idToken?.tokenString else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No ID token"])))
                return
            }
            
            self.userService.createOrFetchUser(googleUser: user) { result in
                switch result {
                case .success(let user):
                    // Save user data locally
                    UserDefaults.standard.setUser(id: user.id ?? "123",
                                                  googleId: user.googleId,
                                                  email: user.email,
                                                  name: user.name,
                                                  givenName: user.givenName,
                                                  familyName: user.familyName,
                                                  pictureUrl: user.pictureUrl,
                                                  income: user.income)
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
