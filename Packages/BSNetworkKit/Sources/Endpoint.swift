//
//  Endpoint.swift
//  BSNetworkKit
//
//  Created by Bahadir Sonmez on 11.12.2025.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public protocol Endpoint {
    associatedtype Parameters: Encodable = EmptyParameters
    
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: Parameters? { get }
    var urlCachePolicy: URLRequest.CachePolicy { get }
}

// MARK: - Empty Parameters

public struct EmptyParameters: Encodable {}

// MARK: - Default Implementations

extension Endpoint {
    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    public var parameters: Parameters? {
        return nil
    }
    
    public var urlCachePolicy: URLRequest.CachePolicy {
        return .useProtocolCachePolicy
    }
}
