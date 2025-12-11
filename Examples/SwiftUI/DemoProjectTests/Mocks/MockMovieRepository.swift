//
//  MockMovieRepository.swift
//  DemoProjectTests
//
//  Created by Bahadir Sonmez on 17.12.2025.
//

import Foundation
import BSSwiftUI
@testable import DemoProject
import DemoNetwork

final class MockMovieRepository: MovieRepositoryProtocol {
    
    // MARK: - Stub Data
    
    var latestMoviesResult: Result<MovieListResponse, Error> = .success(MovieListResponse.mock())
    var searchMoviesResult: Result<MovieListResponse, Error> = .success(MovieListResponse.mock())
    
    // MARK: - Call Tracking
    
    var getLatestMoviesCallCount = 0
    var getLatestMoviesLastPage: Int?
    var getLatestMoviesLastForceRefresh: Bool?
        
    var searchMoviesCallCount = 0
    var searchMoviesLastQuery: String?
    var searchMoviesLastPage: Int?
    
    // MARK: - Protocol Methods
    
    func getLatestMovies(page: Int, forceRefresh: Bool) async throws -> MovieListResponse {
        getLatestMoviesCallCount += 1
        getLatestMoviesLastPage = page
        getLatestMoviesLastForceRefresh = forceRefresh
        
        switch latestMoviesResult {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
    
    func searchMovies(query: String, page: Int) async throws -> MovieListResponse {
        searchMoviesCallCount += 1
        searchMoviesLastQuery = query
        searchMoviesLastPage = page
        
        switch searchMoviesResult {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
    
    // MARK: - Reset
    
    func reset() {
        latestMoviesResult = .success(MovieListResponse.mock())
        searchMoviesResult = .success(MovieListResponse.mock())
        getLatestMoviesCallCount = 0
        getLatestMoviesLastPage = nil
        getLatestMoviesLastForceRefresh = nil
        searchMoviesCallCount = 0
        searchMoviesLastQuery = nil
        searchMoviesLastPage = nil
    }
}

// MARK: - Mock Data

extension MovieListResponse {
    static func mock(
        page: Int = 1,
        totalPages: Int = 10,
        results: [Movie] = Movie.mockList()
    ) -> MovieListResponse {
        MovieListResponse(
            page: page,
            results: results,
            totalPages: totalPages
        )
    }
    
    static func emptyMock() -> MovieListResponse {
        MovieListResponse(
            page: 1,
            results: [],
            totalPages: 1
        )
    }
}

extension Movie {
    static func mock(
        id: Int = 1,
        title: String = "Test Movie",
        overview: String = "Test overview",
        posterPath: String? = "/test.jpg",
        backdropPath: String? = "/backdrop.jpg",
        releaseDate: String? = "2025-01-01",
        voteAverage: Double? = 8.5,
        originalLanguage: String? = "en",
        originalTitle: String? = "Original Test Movie"
    ) -> Movie {
        Movie(
            id: id,
            title: title,
            overview: overview,
            posterPath: posterPath,
            backdropPath: backdropPath,
            releaseDate: releaseDate,
            voteAverage: voteAverage,
            originalLanguage: originalLanguage,
            originalTitle: originalTitle
        )
    }
    
    static func mockList(count: Int = 5) -> [Movie] {
        (1...count).map { index in
            Movie.mock(
                id: index,
                title: "Movie \(index)",
                overview: "Overview for movie \(index)"
            )
        }
    }
}
