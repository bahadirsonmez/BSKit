//
//  PreviewMovieRepository.swift
//  DemoProject
//
//  Created by Bahadir Sonmez on 21.12.2025.
//

import Foundation
import DemoNetwork

// MARK: - Preview Movie Repository

final class PreviewMovieRepository: MovieRepositoryProtocol {
    
    func getLatestMovies(page: Int, forceRefresh: Bool) async throws -> MovieListResponse {
        MovieListResponse(
            page: 1,
            results: PreviewMocks.movies,
            totalPages: 1
        )
    }
    
    func searchMovies(query: String, page: Int) async throws -> MovieListResponse {
        MovieListResponse(
            page: 1,
            results: PreviewMocks.movies.filter { $0.title.localizedCaseInsensitiveContains(query) },
            totalPages: 1
        )
    }
}
