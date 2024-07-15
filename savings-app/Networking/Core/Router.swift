//
//  Router.swift
//  savings-app
//
//  Created by Kujtim Saliu on 3.7.24.
//

import Foundation

class Router<EndPoint: EndPointType>: NetworkRouter {
    private var task: URLSessionTask?
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        } catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.httpMethod.rawValue
        
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters, _):
                try self.configureParameters(bodyParameters: bodyParameters, request: &request)
            }
            
            if let headers = route.headers {
                self.addAdditionalHeaders(headers, request: &request)
            }
            
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: [String: Any]?, request: inout URLRequest) throws {
        if let bodyParameters = bodyParameters {
            if request.value(forHTTPHeaderField: "Content-Type") == "application/x-www-form-urlencoded" {
                request.httpBody = bodyParameters.percentEncoded()
            } else {
                request.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters)
            }
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: [String: String], request: inout URLRequest) {
        for (key, value) in additionalHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}




extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}
