//
//  URLRequestBuilder.swift
//  BSNetworkKit
//
//  Created by Bahadir Sonmez on 11.12.2025.
//

import Foundation

public struct URLRequestBuilder {
    
    public static func build<E: Endpoint>(from endpoint: E) -> URLRequest? {
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.cachePolicy = endpoint.urlCachePolicy
        request.allHTTPHeaderFields = endpoint.headers
        
        if let parameters = endpoint.parameters {
            request = applyParameters(parameters, to: request, method: endpoint.method)
        }
        
        return request
    }
    
    // MARK: - Private
    
    private static func applyParameters<P: Encodable>(_ parameters: P, to request: URLRequest, method: HTTPMethod) -> URLRequest {
        var request = request
        
        switch method {
        case .get:
            request.url = appendQueryItems(parameters, to: request.url)
        case .post, .put, .delete:
            request.httpBody = try? JSONEncoder().encode(parameters)
        }
        
        return request
    }
    
    private static func appendQueryItems<P: Encodable>(_ parameters: P, to url: URL?) -> URL? {
        guard let url = url,
              var components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let data = try? JSONEncoder().encode(parameters),
              let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return url
        }
        
        components.queryItems = dict.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        return components.url
    }
}
