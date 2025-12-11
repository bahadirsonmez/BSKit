//
//  BaseRepository.swift
//  BSNetworkKit
//
//  Created by Bahadir Sonmez on 13.12.2025.
//

import Foundation

// MARK: - Base Repository Protocol

public protocol BaseRepositoryProtocol {
    var networkClient: NetworkClientProtocol { get }
    
    func fetch<T: Decodable, E: Endpoint>(_ endpoint: E) async throws -> T
    func fetch<T: Decodable, E: Endpoint>(_ endpoint: E, retryPolicy: RetryPolicy) async throws -> T
}

// MARK: - Default Implementation

public extension BaseRepositoryProtocol {
    
    func fetch<T: Decodable, E: Endpoint>(_ endpoint: E) async throws -> T {
        try await networkClient.request(endpoint)
    }
    
    func fetch<T: Decodable, E: Endpoint>(_ endpoint: E, retryPolicy: RetryPolicy) async throws -> T {
        try await networkClient.request(endpoint, retryPolicy: retryPolicy)
    }
}

// MARK: - Base Repository

open class BaseRepository: BaseRepositoryProtocol {
    
    public let networkClient: NetworkClientProtocol
    
    public nonisolated init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
}
