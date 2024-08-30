//
//  BudgetService.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//

import Foundation

class BudgetService {
    static let shared = BudgetService()
    private let baseURL = "http://127.0.0.1:8000"
    
    func getBudgets(completion: @escaping (Result<[Budget], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/budgets") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let budgets = try JSONDecoder().decode([Budget].self, from: data)
                completion(.success(budgets))
            } catch {
                print("Decoding error: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response data: \(responseString)")
                }
                completion(.failure(error))
            }
        }.resume()
    }
    
    func createBudget(_ budget: Budget, completion: @escaping (Result<Budget, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/budgets") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let jsonData = try encoder.encode(budget)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let newBudget = try decoder.decode(Budget.self, from: data)
                completion(.success(newBudget))
            } catch {
                print("Decoding error: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response data: \(responseString)")
                }
                completion(.failure(error))
            }
        }.resume()
    }
}
