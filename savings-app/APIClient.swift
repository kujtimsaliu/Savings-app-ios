//
//  APIClient.swift
//  savings-app
//
//  Created by Kujtim Saliu on 2.7.24.
//

import Foundation

class APIClient {
    static let shared = APIClient()
    private let baseURL = "http://127.0.0.1:8000"
    private var authToken: String?
    
    private init() {}
    
    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        print("Attempting to log in with email: \(email)")
        let url = URL(string: "\(baseURL)/users/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let body = "username=\(email)&password=\(password)"
        request.httpBody = body.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received from login request")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let token = json?["access_token"] as? String {
                    self.authToken = token
                    print("Login successful. Token received.")
                    completion(.success(token))
                } else {
                    print("Invalid response from login request")
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                }
            } catch {
                print("Error parsing login response: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getExpenses(completion: @escaping (Result<[Expense], Error>) -> Void) {
        print("Attempting to fetch expenses")
        guard let token = authToken else {
            print("Not authenticated. Cannot fetch expenses.")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not authenticated"])))
            return
        }
        
        let url = URL(string: "\(baseURL)/expenses")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching expenses: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received from expenses request")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let expenses = try JSONDecoder().decode([Expense].self, from: data)
                print("Successfully fetched \(expenses.count) expenses")
                completion(.success(expenses))
            } catch {
                print("Error parsing expenses response: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
}
