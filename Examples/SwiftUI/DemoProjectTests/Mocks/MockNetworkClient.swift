//
//  MockNetworkClient.swift
//  DemoProjectTests
//
//  Created by Bahadir Sonmez on 17.12.2025.
//

import Foundation
@testable import DemoProject
import BSNetworkKit

final class MockNetworkClient: NetworkClientProtocol {
    
    // MARK: - Stub Data
    
    var requestResult: Result<Any, Error> = .failure(NSError(domain: "Mock", code: 0))
    
    // MARK: - Call Tracking
    
    var requestCallCount = 0
    
    // MARK: - Protocol Methods
    
    func request<T: Decodable, E: Endpoint>(_ endpoint: E) async throws -> T {
        requestCallCount += 1
        
        switch requestResult {
        case .success(let data):
            guard let result = data as? T else {
                throw NSError(domain: "Mock", code: 1, userInfo: [NSLocalizedDescriptionKey: "Type mismatch"])
            }
            return result
        case .failure(let error):
            throw error
        }
    }
    
    func request<T: Decodable, E: Endpoint>(_ endpoint: E, retryPolicy: RetryPolicy) async throws -> T {
        try await request(endpoint)
    }
    
    // MARK: - Reset
    
    func reset() {
        requestResult = .failure(NSError(domain: "Mock", code: 0))
        requestCallCount = 0
    }
}
