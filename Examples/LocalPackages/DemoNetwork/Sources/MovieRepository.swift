//
//  MovieRepository.swift
//  DemoProject
//
//  Created by Bahadir Sonmez on 13.12.2025.
//

import Foundation
import BSNetworkKit

// MARK: - Movie Repository Protocol

public protocol MovieRepositoryProtocol {
    func getLatestMovies(page: Int, forceRefresh: Bool) async throws -> MovieListResponse
    func searchMovies(query: String, page: Int) async throws -> MovieListResponse
}

// MARK: - Movie Repository

public final class MovieRepository: BaseRepository, MovieRepositoryProtocol {
    
    private let retryPolicy: RetryPolicy = .default
    
    public nonisolated override init(networkClient: NetworkClientProtocol) {
        super.init(networkClient: networkClient)
    }
    
    public func getLatestMovies(page: Int, forceRefresh: Bool = false) async throws -> MovieListResponse {
        let endpoint = MovieEndpoint.latest(page: page, forceRefresh: forceRefresh)
        return try await fetch(endpoint, retryPolicy: retryPolicy)
    }
    
    public func searchMovies(query: String, page: Int) async throws -> MovieListResponse {
        try await fetch(MovieEndpoint.search(query: query, page: page), retryPolicy: retryPolicy)
    }
}
