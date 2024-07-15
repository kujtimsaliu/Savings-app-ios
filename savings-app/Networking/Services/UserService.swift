//
//  UserService.swift
//  savings-app
//
//  Created by Kujtim Saliu on 3.7.24.
//

import Foundation
import Foundation

struct UserService {
    static let shared = UserService()
    let router = Router<UserAPI>()
    
    private init() {}
    
    func login(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        router.request(.login(username: username, password: password)) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoDataError", code: 0, userInfo: nil)))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let token = json["access_token"] as? String {
                    completion(.success(token))
                } else {
                    let responseString = String(data: data, encoding: .utf8) ?? "Unable to decode response"
                    print("Invalid response: \(responseString)")
                    completion(.failure(NSError(domain: "InvalidResponseError", code: 0, userInfo: ["responseString": responseString])))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    func googleAuth(idToken: String, completion: @escaping (Result<User, Error>) -> Void) {
        router.request(.googleAuth(idToken: idToken)) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoDataError", code: 0, userInfo: nil)))
                return
            }
            
            // Print raw response
            if let responseString = String(data: data, encoding: .utf8) {
                print("Raw response: \(responseString)")
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let detail = json["detail"] as? String {
                    completion(.failure(NSError(domain: "ServerError", code: 0, userInfo: ["detail": detail])))
                } else {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    completion(.success(user))
                }
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }
    }

}
