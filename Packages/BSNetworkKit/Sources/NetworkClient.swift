//
//  NetworkClient.swift
//  BSNetworkKit
//
//  Created by Bahadir Sonmez on 11.12.2025.
//

import Foundation

// MARK: - Network Client Protocol

public protocol NetworkClientProtocol {
    func request<T: Decodable, E: Endpoint>(_ endpoint: E) async throws -> T
    func request<T: Decodable, E: Endpoint>(_ endpoint: E, retryPolicy: RetryPolicy) async throws -> T
}

// MARK: - Network Client

public final class NetworkClient: NetworkClientProtocol {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    public init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
    }
    
    public func request<T: Decodable, E: Endpoint>(_ endpoint: E) async throws -> T {
        try await performRequest(endpoint)
    }
    
    public func request<T: Decodable, E: Endpoint>(_ endpoint: E, retryPolicy: RetryPolicy) async throws -> T {
        try await performRequestWithRetry(endpoint, retryPolicy: retryPolicy)
    }
}

// MARK: - Request Execution

private extension NetworkClient {
    
    func performRequest<T: Decodable, E: Endpoint>(_ endpoint: E) async throws -> T {
        guard let request = URLRequestBuilder.build(from: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        if endpoint.urlCachePolicy == .reloadIgnoringLocalCacheData {
            session.configuration.urlCache?.removeCachedResponse(for: request)
        }
        
        let (data, response) = try await session.data(for: request)
        return try ResponseHandler.handleAsync(data: data, response: response, decoder: decoder)
    }
    
    func performRequestWithRetry<T: Decodable, E: Endpoint>(_ endpoint: E, retryPolicy: RetryPolicy) async throws -> T {
        var lastError: Error?
        
        for attempt in 0...retryPolicy.maxRetries {
            do {
                return try await performRequest(endpoint)
            } catch {
                lastError = error
                
                guard retryPolicy.shouldRetry(for: error, attempt: attempt) else {
                    throw error
                }
                
                let delay = retryPolicy.delay(for: attempt)
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
        }
        
        throw NetworkError.maxRetriesExceeded(lastError: lastError ?? NetworkError.unknown(NSError(domain: "Unknown", code: -1)))
    }
}
