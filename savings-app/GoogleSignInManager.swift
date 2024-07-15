//
//  GoogleSignInManager.swift
//  savings-app
//
//  Created by Kujtim Saliu on 7.7.24.
//

import UIKit
import GoogleSignIn

class GoogleSignInManager {
    static let shared = GoogleSignInManager()
    
    private init() {}
    
    func signIn(presenting viewController: UIViewController, completion: @escaping (Result<String, Error>) -> Void) {
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                completion(.failure(NSError(domain: "GoogleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get ID token"])))
                return
            }
            
            completion(.success(idToken))
        }
    }
}
