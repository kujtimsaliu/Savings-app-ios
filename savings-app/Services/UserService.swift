//
//  UserService.swift
//  savings-app
//
//  Created by Kujtim Saliu on 3.7.24.
//

import UIKit
import GoogleSignIn

class UserService {
    static let shared = UserService()
    private init() {}
    
    private let baseURL = "http://127.0.0.1:8000"
    //    private let backendURL = "http://127.0.0.1:8000"
    
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = URL(string: baseURL + "/users/signup")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func googleAuth(idToken: String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = URL(string: baseURL + "/auth/google")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "id_token": idToken
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func createOrFetchUser(googleUser: GIDGoogleUser, completion: @escaping (Result<User, Error>) -> Void) {
        let url = URL(string: baseURL + "/users")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "google_id": googleUser.userID ?? "",
            "email": googleUser.profile?.email ?? "",
            "name": googleUser.profile?.name ?? "",
            "given_name": googleUser.profile?.givenName ?? "",
            "family_name": googleUser.profile?.familyName ?? "",
            "picture_url": googleUser.profile?.imageURL(withDimension: 100)?.absoluteString ?? ""
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            if let dataString = String(data: data, encoding: .utf8) {
                print("Received data: \(dataString)")
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let detail = json["detail"] as? String {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: detail])))
                } else {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    completion(.success(user))
                }
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}

//class UserService {
//    static let shared = UserService()
//    private init() {}
//
//    private let backendURL = "http://127.0.0.1:8000"
//
//    func createOrFetchUser(googleUser: GIDGoogleUser, completion: @escaping (Result<User, Error>) -> Void) {
//        let url = URL(string: backendURL + "/users")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let body: [String: Any] = [
//            "google_id": googleUser.userID ?? "",
//            "email": googleUser.profile?.email ?? "",
//            "name": googleUser.profile?.name ?? "",
//            "given_name": googleUser.profile?.givenName ?? "",
//            "family_name": googleUser.profile?.familyName ?? "",
//            "picture_url": googleUser.profile?.imageURL(withDimension: 100)?.absoluteString ?? ""
//        ]
//
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
//                return
//            }
//
//            if let dataString = String(data: data, encoding: .utf8) {
//                print("Received data: \(dataString)")
//            }
//
//            do {
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                   let detail = json["detail"] as? String {
//                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: detail])))
//                } else {
//                    let user = try JSONDecoder().decode(User.self, from: data)
//                    completion(.success(user))
//                }
//            } catch {
//                print("Decoding error: \(error)")
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//}
