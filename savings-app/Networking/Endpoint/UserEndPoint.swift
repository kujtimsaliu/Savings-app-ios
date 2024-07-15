//
//  UserEndPoint.swift
//  savings-app
//
//  Created by Kujtim Saliu on 3.7.24.
//

import Foundation

enum UserAPI {
    case login(username: String, password: String)
    case googleAuth(idToken: String)
}

extension UserAPI: EndPointType {
    var baseURL: URL {
        return URL(string: "http://127.0.0.1:8000")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/users/token"
        case .googleAuth:
            return "/auth/google"
        }
        
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .login, .googleAuth:
            return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .login(let username, let password):
            let body = "username=\(username)&password=\(password)"
            return .requestParameters(bodyParameters: ["body": body], urlParameters: nil)
        case .googleAuth(let idToken):
            return .requestParameters(bodyParameters: ["id_token": idToken], urlParameters: nil)
        }

    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/x-www-form-urlencoded"]
    }
}
