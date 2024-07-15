//
//  Httptask.swift
//  savings-app
//
//  Created by Kujtim Saliu on 3.7.24.
//

import Foundation

enum HTTPTask {
    case request
    case requestParameters(bodyParameters: [String: Any]?, urlParameters: [String: Any]?)
}
