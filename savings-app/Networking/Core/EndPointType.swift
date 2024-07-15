//
//  EndPointType.swift
//  savings-app
//
//  Created by Kujtim Saliu on 3.7.24.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: [String: String]? { get }
}
